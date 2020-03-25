/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   An strlen for MRISC32
   Copyright (C) 2020  Marcus Geelnard

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
; size_t strlen(const char* str)
;   r1 = str
;-----------------------------------------------------------------------------

    .globl  strlen
    .p2align 2
    .type   strlen,@function

strlen:
    mov     r2, r1
    ldi     r1, #0

    ; Check if the string address is word-aligned.
    and     r6, r2, #3
    bnz     r6, unaligned

aligned:
    ldw     r3, [r2, r1]
    add     r1, r1, #4
    seq.b   r4, r3, z
    bz      r4, aligned

    add     r1, r1, #-4
    shuf    r5, r3, #0b0100100100000    ; Extract byte #0
    bz      r5, done
    add     r1, r1, #1
    shuf    r5, r3, #0b0100100100001    ; Extract byte #1
    bz      r5, done
    add     r1, r1, #1
    shuf    r5, r3, #0b0100100100010    ; Extract byte #2
    bz      r5, done
    add     r1, r1, #1

done:
    ret

unaligned:
    sub     r6, #4, r6      ; r6 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldb     r3, [r2, r1]
    add     r6, r6, #-1
    bz      r3, done
    add     r1, r1, #1
    bz      r6, aligned

    ; 2nd unaligned byte.
    ldb     r3, [r2, r1]
    add     r6, r6, #-1
    bz      r3, done
    add     r1, r1, #1
    bz      r6, aligned

    ; 3rd (last) unaligned byte.
    ldb     r3, [r2, r1]
    bz      r3, done
    add     r1, r1, #1
    b       aligned

    .size   strlen,.-strlen

