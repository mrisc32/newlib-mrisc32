/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   An strcpy for MRISC32
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
; char* strcpy(char* dest, const char* src)
;   s1 = dest
;   s2 = src
;-----------------------------------------------------------------------------

    .globl  strcpy
    .p2align 2
    .type   strcpy,@function

strcpy:
    ldi     s3, #0                      ; s3 is the string index

    ; Check if both strings have equal alignment.
    and     s6, s1, #3
    and     s7, s2, #3
    seq     s7, s6, s7
    bns     s7, slow

    ; Check if the string address is word-aligned.
    bnz     s6, unaligned

aligned:
    ldw     s4, s2, s3
    seq.b   s5, s4, z
    bnz     s5, found_zero
    stw     s4, s1, s3
    add     s3, s3, #4
    b       aligned

found_zero:
    add     s6, s1, s3
    shuf    s5, s4, #0b0100100100000    ; Extract byte #0
    stb     s5, s6, #0
    bz      s5, done
    shuf    s5, s4, #0b0100100100001    ; Extract byte #1
    stb     s5, s6, #1
    bz      s5, done
    shuf    s5, s4, #0b0100100100010    ; Extract byte #2
    stb     s5, s6, #2
    bz      s5, done
    stb     z, s6, #3                   ; We know that byte #3 is zero

done:
    ; Note: s1 points to dest, which is the correct return value.
    ret

unaligned:
    sub     s6, #4, s6      ; s6 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldb     s4, s2, s3
    add     s6, s6, #-1
    stb     s4, s1, s3
    bz      s4, done
    add     s3, s3, #1
    bz      s6, aligned

    ; 2nd unaligned byte.
    ldb     s4, s2, s3
    add     s6, s6, #-1
    stb     s4, s1, s3
    bz      s4, done
    add     s3, s3, #1
    bz      s6, aligned

    ; 3rd (last) unaligned byte.
    ldb     s4, s2, s3
    stb     s4, s1, s3
    bz      s4, done
    add     s3, s3, #1
    b       aligned

slow:
    ldb     s4, s2, s3
    stb     s4, s1, s3
    add     s3, s3, #1
    bnz     s4, slow

    ; Note: s1 points to dest, which is the correct return value.
    ret

    .size   strcpy,.-strcpy

