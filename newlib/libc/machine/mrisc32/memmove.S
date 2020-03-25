/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   A memmove for MRISC32
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
; void* memmove(void* dest, const void* src, size_t count)
;   r1 = dest
;   r2 = src
;   r3 = count
;-----------------------------------------------------------------------------

    .globl  memmove
    .p2align 2
    .type   memmove,@function

memmove:
    sleu    r4, r1, r2
    bs      r4, memcpy      ; memcpy() implements a forward copy.

    ; Nothing to do?
    bz      r3, no_op

    mov     r5, vl          ; Preserve vl (it's a callee-saved register).
    mov     r4, r1          ; r4 = dest (we need to preserve r1)

    ; Do a backwards copy to avoid overlap.
    add     r6, r3, #-1
    add     r4, r4, r6
    add     r2, r2, r6

    ; Is the length long enough to bother with optizations?
    sltu    r7, r3, #24
    bs      r7, slow

    ; Are src and dest equally aligned (w.r.t 4-byte boundaries).
    and     r6, r4, #3
    and     r7, r2, #3
    seq     r7, r6, r7
    bns     r7, slow        ; Use the slow case unless equally aligned.

    ; Do we need to align before the main loop?
    seq     r7, r6, #3
    bns     r7, unaligned

aligned:
    ; Vectorized word-copying loop.
    lsr     r7, r3, #2      ; r7 = number of words (> 0 due to earlier length requirement)
    add     r2, r2, #-3
    add     r4, r4, #-3
    cpuid   r6, z, z        ; r6 = max vector length.
1:
    min     vl, r6, r7
    sub     r7, r7, vl
    ldw     v1, [r2, #-4]
    sub     r8, z, vl
    ldea    r2, [r2, r8*4]
    stw     v1, [r4, #-4]
    ldea    r4, [r4, r8*4]
    bnz     r7, 1b

    ; Tail: Do a 1-3 bytes copy via a vector register.
    and     vl, r3, #3      ; vl = bytes left after the aligned loop.
    bz      vl, done
    add     r2, r2, #3
    ldb     v1, [r2, #-1]
    add     r4, r4, #3
    stb     v1, [r4, #-1]

done:
    mov     vl, r5          ; Restore vl.

    ; At this point r1 should contain it's original value (dest).
    ret

unaligned:
    ; Align: Do a 1-3 bytes copy via a vector register, and adjust the memory
    ; pointers and the count.
    add     vl, r6, #1      ; vl = bytes left until aligned.
    sub     r3, r3, vl
    ldb     v1, [r2, #-1]
    sub     r2, r2, vl
    stb     v1, [r4, #-1]
    sub     r4, r4, vl
    b       aligned

slow:
    ; Simple vectorized byte-copy loop (this is typically 4x slower than a
    ; word-copy loop).
    cpuid   r6, z, z        ; r6 = max vector length.
1:
    min     vl, r6, r3
    sub     r3, r3, vl
    ldb     v1, [r2, #-1]
    sub     r2, r2, vl
    stb     v1, [r4, #-1]
    sub     r4, r4, vl
    bnz     r3, 1b

    mov     vl, r5          ; Restore vl.

no_op:
    ret

    .size   memmove,.-memmove


