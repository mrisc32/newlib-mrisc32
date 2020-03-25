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
;   r1 = ptr
;   r2 = value
;   r3 = num
;-----------------------------------------------------------------------------

    .globl  memset
    .p2align 2
    .type   memset,@function

memset:
    bz      r3, no_op       ; Nothing to do?

    mov     r6, vl          ; Preserve vl

    ; We don't want to touch r1, as the function must return ptr.
    mov     r7, r1

    ; Start by filling up the vector regiser v1 with the fill value.
    cpuid   vl, z, z
    shuf    r2, r2, #0      ; Duplicate value to all four bytes of the word
    mov     v1, r2          ; Set all words of v1 to the value

    ; Is the target memory address aligned?
    and     r5, r7, #3
    bnz     r5, unaligned

aligned:
    lsr     r5, r3, #2      ; r5 = number of words to write
    bz      r5, tail
    cpuid   r4, z, z        ; r4 = max vector length
1$:
    min     vl, r5, r4
    sub     r5, r5, vl
    stw     v1, r7, #4
    ldea    r7, r7, vl*4
    bnz     r5, 1$

tail:
    and     vl, r3, #3      ; vl = tail length (0-3 bytes)
    stb     v1, r7, #1

    mov     vl, r6          ; Restore vl
no_op:
    ret

unaligned:
    ; Make aligned (1-3 bytes).
    sub     r5, #4, r5      ; r5 = bytes until aligned
    min     vl, r3, r5
    sub     r3, r3, vl
    stb     v1, r7, #1
    ldea    r7, r7, vl
    bnz     r3, aligned

    mov     vl, r6          ; Restore vl
    ret

    .size   memset,.-memset

