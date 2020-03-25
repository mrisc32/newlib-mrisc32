/* A setjmp.c for MRISC32
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

; setjmp/longjmp for mrisc32.  The jmpbuf looks like this:
;
; Register        jmpbuf offset
;   s16             0x00
;   s17             0x04
;   s18             0x08
;   s19             0x0c
;   s20             0x10
;   s21             0x14
;   s22             0x18
;   s23             0x1c
;   s24             0x20
;   s25             0x24
;   fp              0x28
;   tp              0x2c
;   sp              0x30
;   vl              0x34
;   lr              0x38
       
        .text
        .global setjmp
        .type   setjmp,@function
setjmp:
	stw	s16, s1, #0x00
	stw	s17, s1, #0x04
	stw	s18, s1, #0x08
	stw	s19, s1, #0x0c
	stw	s20, s1, #0x10
	stw	s21, s1, #0x14
	stw	s22, s1, #0x18
	stw	s23, s1, #0x1c
	stw	s24, s1, #0x20
	stw	s25, s1, #0x24
	stw	fp, s1, #0x28
	stw	tp, s1, #0x2c
	stw	sp, s1, #0x30
	stw	vl, s1, #0x34
	stw	lr, s1, #0x38
	ldi	s1, #0
	ret

	.size	setjmp,.-setjmp

	.global	longjmp
	.type	longjmp,@function
longjmp:
	ldw	s16, s1, #0x00
	ldw	s17, s1, #0x04
	ldw	s18, s1, #0x08
	ldw	s19, s1, #0x0c
	ldw	s20, s1, #0x10
	ldw	s21, s1, #0x14
	ldw	s22, s1, #0x18
	ldw	s23, s1, #0x1c
	ldw	s24, s1, #0x20
	ldw	s25, s1, #0x24
	ldw	fp, s1, #0x28
	ldw	tp, s1, #0x2c
	ldw	sp, s1, #0x30
	ldw	vl, s1, #0x34
	ldw	lr, s1, #0x38
	seq	s1, s2, #0		; Correct?
	ret

	.size	longjmp,.-longjmp
