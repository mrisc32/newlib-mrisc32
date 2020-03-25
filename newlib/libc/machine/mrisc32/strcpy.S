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
;   r1 = dest
;   r2 = src
;-----------------------------------------------------------------------------

    .globl  strcpy
    .p2align 2
    .type   strcpy,@function

strcpy:
    ldi     r3, #0                      ; r3 is the string index

    ; Check if both strings have equal alignment.
    and     r6, r1, #3
    and     r7, r2, #3
    seq     r7, r6, r7
    bns     r7, slow

    ; Check if the string address is word-aligned.
    bnz     r6, unaligned

aligned:
    ldw     r4, [r2, r3]
    seq.b   r5, r4, z
    bnz     r5, found_zero
    stw     r4, [r1, r3]
    add     r3, r3, #4
    b       aligned

found_zero:
    add     r6, r1, r3
    shuf    r5, r4, #0b0100100100000    ; Extract byte #0
    stb     r5, [r6, #0]
    bz      r5, done
    shuf    r5, r4, #0b0100100100001    ; Extract byte #1
    stb     r5, [r6, #1]
    bz      r5, done
    shuf    r5, r4, #0b0100100100010    ; Extract byte #2
    stb     r5, [r6, #2]
    bz      r5, done
    stb     z, [r6, #3]                 ; We know that byte #3 is zero

done:
    ; Note: r1 points to dest, which is the correct return value.
    ret

unaligned:
    sub     r6, #4, r6      ; r6 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldb     r4, [r2, r3]
    add     r6, r6, #-1
    stb     r4, [r1, r3]
    bz      r4, done
    add     r3, r3, #1
    bz      r6, aligned

    ; 2nd unaligned byte.
    ldb     r4, [r2, r3]
    add     r6, r6, #-1
    stb     r4, [r1, r3]
    bz      r4, done
    add     r3, r3, #1
    bz      r6, aligned

    ; 3rd (last) unaligned byte.
    ldb     r4, [r2, r3]
    stb     r4, [r1, r3]
    bz      r4, done
    add     r3, r3, #1
    b       aligned

slow:
    ldb     r4, [r2, r3]
    stb     r4, [r1, r3]
    add     r3, r3, #1
    bnz     r4, slow

    ; Note: s1 points to dest, which is the correct return value.
    ret

    .size   strcpy,.-strcpy

