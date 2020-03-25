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
;   s1 = dest
;   s2 = src
;   s3 = count
;-----------------------------------------------------------------------------

    .globl  memmove
    .p2align 2
    .type   memmove,@function

memmove:
    sleu    s4, s1, s2
    bs      s4, memcpy      ; memcpy() implements a forward copy.

    ; Nothing to do?
    bz      s3, no_op

    mov     s5, vl          ; Preserve vl (it's a callee-saved register).
    mov     s4, s1          ; s4 = dest (we need to preserve s1)

    ; Do a backwards copy to avoid overlap.
    add     s6, s3, #-1
    add     s4, s4, s6
    add     s2, s2, s6

    ; Is the length long enough to bother with optizations?
    sltu    s7, s3, #24
    bs      s7, slow

    ; Are src and dest equally aligned (w.r.t 4-byte boundaries).
    and     s6, s4, #3
    and     s7, s2, #3
    seq     s7, s6, s7
    bns     s7, slow        ; Use the slow case unless equally aligned.

    ; Do we need to align before the main loop?
    seq     s7, s6, #3
    bns     s7, unaligned

aligned:
    ; Vectorized word-copying loop.
    lsr     s7, s3, #2      ; s7 = number of words (> 0 due to earlier length requirement)
    add     s2, s2, #-3
    add     s4, s4, #-3
    cpuid   s6, z, z        ; s6 = max vector length.
1:
    min     vl, s6, s7
    sub     s7, s7, vl
    ldw     v1, s2, #-4
    sub     s8, z, vl
    ldea    s2, s2, s8*4
    stw     v1, s4, #-4
    ldea    s4, s4, s8*4
    bnz     s7, 1b

    ; Tail: Do a 1-3 bytes copy via a vector register.
    and     vl, s3, #3      ; vl = bytes left after the aligned loop.
    bz      vl, done
    add     s2, s2, #3
    ldb     v1, s2, #-1
    add     s4, s4, #3
    stb     v1, s4, #-1

done:
    mov     vl, s5          ; Restore vl.

    ; At this point s1 should contain it's original value (dest).
    ret

unaligned:
    ; Align: Do a 1-3 bytes copy via a vector register, and adjust the memory
    ; pointers and the count.
    add     vl, s6, #1      ; vl = bytes left until aligned.
    sub     s3, s3, vl
    ldb     v1, s2, #-1
    sub     s2, s2, vl
    stb     v1, s4, #-1
    sub     s4, s4, vl
    b       aligned

slow:
    ; Simple vectorized byte-copy loop (this is typically 4x slower than a
    ; word-copy loop).
    cpuid   s6, z, z        ; s6 = max vector length.
1:
    min     vl, s6, s3
    sub     s3, s3, vl
    ldb     v1, s2, #-1
    sub     s2, s2, vl
    stb     v1, s4, #-1
    sub     s4, s4, vl
    bnz     s3, 1b

    mov     vl, s5          ; Restore vl.

no_op:
    ret

    .size   memmove,.-memmove


