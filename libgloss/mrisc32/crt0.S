/* crt0.S -- startup file for MRISC32.
 * 
 * Copyright (c) 2020  Marcus Geelnard
 *
 * The authors hereby grant permission to use, copy, modify, distribute,
 * and license this software and its documentation for any purpose, provided
 * that existing copyright notices are retained in all copies and that this
 * notice is included verbatim in any distributions. No written agreement,
 * license, or royalty fee is required for any of the authorized uses.
 * Modifications to this software may be copyrighted by their authors
 * and need not follow the licensing terms described here, provided that
 * the new terms are clearly indicated on the first page of each file where
 * they apply.
 */

#ifndef STACK_SIZE
#define STACK_SIZE 65536
#endif

	.file	"crt0.S"

	.globl	_start
	.section .text.start, "ax"
	.p2align 2
	.type	_start,@function
_start:
	; We use sbrk() to allocate a stack on the heap. To call sbrk we set
	; up an initial minimal temporary stack.
	ldi	s1, #STACK_SIZE
	ldi	sp, #_end+128	; Temporary stack, just for calling sbrk.
	call	sbrk@pc
	mov	sp, s1

	; Clear the bss area,
	ldi	s1, #__bss_start
	ldi	s2, #__bss_end
	sub	s2, s2, s1
	call	memset@pc

	; Call _init to invoke static constructors, etc.
	;call	_init@pc
	
	; Call _fini at exit time for static destructors.
	;ldi	s1, #_fini
	;call	atexit@pc

	; Fake argc and argv, and call main().
	ldi	s1, #1		; s1 = argc
	ldi	s2, #argv	; s2 = argv
	call	main@pc

	; Call exit().
	call	exit@pc

	; Stop (loop forever) if we ever get here.
1:	b	1b

	.size	_start,.-_start


	.section	.rodata
	.p2align	2
argv:
	.word	argv_data

argv_data:
	.asciz	"program"
	.p2align	2

