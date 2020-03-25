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
;   s1 = str
;-----------------------------------------------------------------------------

    .globl  strlen
    .p2align 2
    .type   strlen,@function

strlen:
    mov     s2, s1
    ldi     s1, #0

    ; Check if the string address is word-aligned.
    and     s6, s2, #3
    bnz     s6, unaligned

aligned:
    ldw     s3, s2, s1
    add     s1, s1, #4
    seq.b   s4, s3, z
    bz      s4, aligned

    add     s1, s1, #-4
    shuf    s5, s3, #0b0100100100000    ; Extract byte #0
    bz      s5, done
    add     s1, s1, #1
    shuf    s5, s3, #0b0100100100001    ; Extract byte #1
    bz      s5, done
    add     s1, s1, #1
    shuf    s5, s3, #0b0100100100010    ; Extract byte #2
    bz      s5, done
    add     s1, s1, #1

done:
    ret

unaligned:
    sub     s6, #4, s6      ; s6 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldb     s3, s2, s1
    add     s6, s6, #-1
    bz      s3, done
    add     s1, s1, #1
    bz      s6, aligned

    ; 2nd unaligned byte.
    ldb     s3, s2, s1
    add     s6, s6, #-1
    bz      s3, done
    add     s1, s1, #1
    bz      s6, aligned

    ; 3rd (last) unaligned byte.
    ldb     s3, s2, s1
    bz      s3, done
    add     s1, s1, #1
    b       aligned

    .size   strlen,.-strlen

