/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   A memcmp for MRISC32
   Copyright (C) 2021  Marcus Geelnard

   The authors hereby grant permission to use, copy, modify, distribute,
   and license this software and its documentation for any purpose, provided
   that existing copyright notices are retained in all copies and that this
   notice is included verbatim in any distributions. No written agreement,
   license, or royalty fee is required for any of the authorized uses.
   Modifications to this software may be copyrighted by their authors
   and need not follow the licensing terms described here, provided that
   the new terms are clearly indicated on the first page of each file where
   they apply.  */

    .text

;-----------------------------------------------------------------------------
; int memcmp(const void* lhs, const void* rhs, size_t count)
;   r1 = lhs
;   r2 = rhs
;   r3 = count
;-----------------------------------------------------------------------------

    .globl  memcmp
    .p2align 2
    .type   memcmp,@function

memcmp:
    mov     r4, r1          ; r4 = lhs
    ldi     r5, #0          ; r5 = current position

    ; Check if the count is large enough to bother with aligned operations.
    sltu    r6, r3, #8
    bs      r6, 2f

    ; Check if both pointers are word-aligned.
    or      r6, r4, r2
    and     r6, r6, #3
    bnz     r6, 2f

    ; Word-aligned loop: Compare four bytes at a time.
    add     r8, r3, #-3     ; (r8 > 0 due to earlier size constraint)
1:
    sltu    r6, r5, r8      ; At least four bytes left?
    bns     r6, 2f          ; TODO(m): Use the fast path instead, but mask the tail.
    ldw     r6, [r4, r5]
    ldw     r7, [r2, r5]
    add     r5, r5, #4
    seq     r8, r6, r7
    bs      r8, 1b

    ; Return the first non-zero diff among the last four bytes that we checked.
    ebfu    r1, r6, #<0:8>
    ebfu    r2, r7, #<0:8>
    sub     r1, r1, r2
    bnz     r1, 4f
    ebfu    r1, r6, #<8:8>
    ebfu    r2, r7, #<8:8>
    sub     r1, r1, r2
    bnz     r1, 4f
    ebfu    r1, r6, #<16:8>
    ebfu    r2, r7, #<16:8>
    sub     r1, r1, r2
    bnz     r1, 4f
    ebfu    r1, r6, #<24:8>
    ebfu    r2, r7, #<24:8>
    sub     r1, r1, r2
    ret

2:
    ldi     r1, #0          ; r1 = the result value (difference)
3:
    seq     r6, r5, r3
    bs      r6, 4f
    ldub    r1, [r4, r5]
    ldub    r6, [r2, r5]
    add     r5, r5, #1
    sub     r1, r1, r6
    bz      r1, 3b

4:
    ret

    .size   memcmp,.-memcmp


