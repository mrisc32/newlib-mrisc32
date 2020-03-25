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
;   r1 = lhs
;   r2 = rhs
;-----------------------------------------------------------------------------

    .globl  strcmp
    .p2align 2
    .type   strcmp,@function

strcmp:
    ldi     r3, #0          ; r3 is the string index

    ; Check if both strings have equal alignment.
    and     r6, r1, #3
    and     r7, r2, #3
    seq     r7, r6, r7
    bns     r7, tail

    ; Make sure that the string address is word-aligned.
    bnz     r6, make_aligned

aligned:
    ldw     r4, r1, r3
    ldw     r5, r2, r3
    add     r3, r3, #4

    sne     r6, r4, r5      ; Are the words different?
    bs      r6, found_diff

    seq.b   r6, r4, z       ; Do we have a zero byte in the word?
    bz      r6, aligned

    ; If we got this far, the strings are equal.
    ldi     r1, #0
    ret

found_diff:
    add     r3, r3, #-4     ; Rewind and do the last four bytes in the tail loop

tail:
    ldub    r4, r1, r3
    ldub    r5, r2, r3
    add     r3, r3, #1
    sub     r6, r4, r5
    bnz     r6, done
    bnz     r5, tail

done:
    mov     r1, r6
    ret

make_aligned:
    sub     r7, #4, r6      ; r7 = number of bytes until aligned (1-3)

    ; 1st unaligned byte.
    ldub    r4, r1, r3
    ldub    r5, r2, r3
    add     r7, r7, #-1
    sub     r6, r4, r5
    bnz     r6, done
    bz      r4, done
    add     r3, r3, #1
    bz      r7, aligned

    ; 2nd unaligned byte.
    ldub    r4, r1, r3
    ldub    r5, r2, r3
    add     r7, r7, #-1
    sub     r6, r4, r5
    bnz     r6, done
    bz      r4, done
    add     r3, r3, #1
    bz      r7, aligned

    ; 3rd (last) unaligned byte.
    ldub    r4, r1, r3
    ldub    r5, r2, r3
    sub     r6, r4, r5
    bnz     r6, done
    bz      r4, done
    add     r3, r3, #1
    b       aligned

    .size   strcmp,.-strcmp

