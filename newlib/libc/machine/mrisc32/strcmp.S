/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   An strcmp for MRISC32
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
; int strcmp(const char* lhs, const char* rhs)
;   s1 = lhs
;   s2 = rhs
;-----------------------------------------------------------------------------

    .globl  strcmp
    .p2align 2
    .type   strcmp,@function

strcmp:
    ldi     s3, #0                      ; s3 is the string index

    ; Check if both strings have equal alignment.
    and     s6, s1, #3
    and     s7, s2, #3
    seq     s7, s6, s7
    bns     s7, tail

    ; Check if the string address is word-aligned.
    bnz     s6, unaligned

aligned:
    ldw     s4, s1, s3
    ldw     s5, s2, s3
    and     s6, s4, s5
    seq.b   s6, s6, z
    bnz     s6, tail
    add     s3, s3, #4
    b       aligned

tail:
    ldub    s4, s1, s3
    ldub    s5, s2, s3
    add     s3, s3, #1
    sub     s6, s4, s5
    bnz     s6, done
    bnz     s5, tail

done:
    mov     s1, s6
    ret

unaligned:
    sub     s7, #4, s6      ; s7 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldub    s4, s1, s3
    ldub    s5, s2, s3
    add     s7, s7, #-1
    sub     s6, s4, s5
    bnz     s6, done
    bz      s4, done
    add     s3, s3, #1
    bz      s7, aligned

    ; 2nd unaligned byte.
    ldub    s4, s1, s3
    ldub    s5, s2, s3
    add     s7, s7, #-1
    sub     s6, s4, s5
    bnz     s6, done
    bz      s4, done
    add     s3, s3, #1
    bz      s7, aligned

    ; 3rd (last) unaligned byte.
    ldub    s4, s1, s3
    ldub    s5, s2, s3
    sub     s6, s4, s5
    bnz     s6, done
    bz      s4, done
    add     s3, s3, #1
    b       aligned

    .size   strcmp,.-strcmp

