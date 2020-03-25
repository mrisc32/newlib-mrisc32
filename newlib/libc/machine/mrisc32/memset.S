/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   A memset for MRISC32
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
; void* memset(void* ptr, int value, size_t num)
;   s1 = ptr
;   s2 = value
;   s3 = num
;-----------------------------------------------------------------------------

    .globl  memset
    .p2align 2
    .type   memset,@function

memset:
    bz      s3, no_op       ; Nothing to do?

    mov     s6, vl          ; Preserve vl

    ; We don't want to touch s1, as the function must return ptr.
    mov     s7, s1

    ; Start by filling up the vector regiser v1 with the fill value.
    cpuid   vl, z, z
    shuf    s2, s2, #0      ; Duplicate value to all four bytes of the word
    mov     v1, s2          ; Set all words of v1 to the value

    ; Is the target memory address aligned?
    and     s5, s7, #3
    bnz     s5, unaligned

aligned:
    lsr     s5, s3, #2      ; s5 = number of words to write
    bz      s5, tail
    cpuid   s4, z, z        ; s4 = max vector length
1$:
    min     vl, s5, s4
    sub     s5, s5, vl
    stw     v1, s7, #4
    ldea    s7, s7, vl*4
    bnz     s5, 1$

tail:
    and     vl, s3, #3      ; vl = tail length (0-3 bytes)
    stb     v1, s7, #1

    mov     vl, s6          ; Restore vl
no_op:
    ret

unaligned:
    ; Make aligned (1-3 bytes).
    sub     s5, #4, s5      ; s5 = bytes until aligned
    min     vl, s3, s5
    sub     s3, s3, vl
    stb     v1, s7, #1
    ldea    s7, s7, vl
    bnz     s3, aligned

    mov     vl, s6          ; Restore vl
    ret

    .size   memset,.-memset

