/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   A memcpy for MRISC32
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
; void* memcpy(void* destination, const void* source, size_t num)
;   r1 = destination
;   r2 = source
;   r3 = num
;-----------------------------------------------------------------------------

    .globl  memcpy
    .p2align 2
    .type   memcpy,@function

memcpy:
    ; Nothing to do?
    bz      r3, no_op

    mov     r5, vl          ; Preserve vl (it's a callee-saved register).
    mov     r4, r1          ; r4 = dest (we need to preserve r1)

    ; Is the length long enough to bother with optizations?
    sltu    r7, r3, #24
    bs      r7, slow

    ; Are src and dest equally aligned (w.r.t 4-byte boundaries).
    and     r6, r4, #3
    and     r7, r2, #3
    seq     r7, r6, r7
    bns     r7, slow        ; Use the slow case unless equally aligned.

    ; Do we need to align before the main loop?
    bz      r6, aligned

unaligned:
    ; Align: Do a 1-3 bytes copy via a vector register, and adjust the memory
    ; pointers and the count.
    sub     vl, #4, r6      ; vl = bytes left until aligned.
    sub     r3, r3, vl
    ldb     v1, [r2, #1]
    add     r2, r2, vl
    stb     v1, [r4, #1]
    add     r4, r4, vl

aligned:
    ; Vectorized word-copying loop.
    lsr     r7, r3, #2      ; r7 > 0 due to earlier length requirement.
    cpuid   r6, z, z        ; r6 = max vector length.
1$:
    min     vl, r6, r7
    sub     r7, r7, vl
    ldw     v1, [r2, #4]
    ldea    r2, [r2, vl*4]
    stw     v1, [r4, #4]
    ldea    r4, [r4, vl*4]
    bnz     r7, 1$

    ; Tail: Do a 1-3 bytes copy via a vector register.
    and     vl, r3, #3      ; vl = bytes left after the aligned loop.
    bz      vl, done
    ldb     v1, [r2, #1]
    stb     v1, [r4, #1]

done:
    mov     vl, r5          ; Restore vl.

no_op:
    ; At this point r1 should contain it's original value (dest).
    ret


slow:
    ; Simple vectorized byte-copy loop (this is typically 4x slower than a
    ; word-copy loop).
    cpuid   r6, z, z        ; r6 = max vector length.
1$:
    min     vl, r6, r3
    sub     r3, r3, vl
    ldb     v1, [r2, #1]
    add     r2, r2, vl
    stb     v1, [r4, #1]
    add     r4, r4, vl
    bnz     r3, 1$

    mov     vl, r5          ; Restore vl.
    ret

    .size   memcpy,.-memcpy


