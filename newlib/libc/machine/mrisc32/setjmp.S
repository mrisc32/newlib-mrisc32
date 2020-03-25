/* -*- mode: mr32asm; tab-width: 4; indent-tabs-mode: nil; -*-
   A setjmp.c for MRISC32
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

; setjmp/longjmp for MRISC32.  The jmpbuf looks like this:
;
; Register        jmpbuf offset
;   r16             0x00
;   r17             0x04
;   r18             0x08
;   r19             0x0c
;   r20             0x10
;   r21             0x14
;   r22             0x18
;   r23             0x1c
;   r24             0x20
;   r25             0x24
;   fp              0x28
;   tp              0x2c
;   sp              0x30
;   vl              0x34
;   lr              0x38

    .text
    .global setjmp
    .type   setjmp,@function
setjmp:
    stw     r16, [r1, #0x00]
    stw     r17, [r1, #0x04]
    stw     r18, [r1, #0x08]
    stw     r19, [r1, #0x0c]
    stw     r20, [r1, #0x10]
    stw     r21, [r1, #0x14]
    stw     r22, [r1, #0x18]
    stw     r23, [r1, #0x1c]
    stw     r24, [r1, #0x20]
    stw     r25, [r1, #0x24]
    stw     fp, [r1, #0x28]
    stw     tp, [r1, #0x2c]
    stw     sp, [r1, #0x30]
    stw     vl, [r1, #0x34]
    stw     lr, [r1, #0x38]
    ldi     r1, #0
    ret

    .size   setjmp,.-setjmp

    .global longjmp
    .type   longjmp,@function
longjmp:
    ldw     r16, [r1, #0x00]
    ldw     r17, [r1, #0x04]
    ldw     r18, [r1, #0x08]
    ldw     r19, [r1, #0x0c]
    ldw     r20, [r1, #0x10]
    ldw     r21, [r1, #0x14]
    ldw     r22, [r1, #0x18]
    ldw     r23, [r1, #0x1c]
    ldw     r24, [r1, #0x20]
    ldw     r25, [r1, #0x24]
    ldw     fp, [r1, #0x28]
    ldw     tp, [r1, #0x2c]
    ldw     sp, [r1, #0x30]
    ldw     vl, [r1, #0x34]
    ldw     lr, [r1, #0x38]
    seq     r1, r2, #0      ; Correct?
    ret

    .size   longjmp,.-longjmp
