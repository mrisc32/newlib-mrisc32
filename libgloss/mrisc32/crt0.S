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
#define STACK_SIZE 256*1024
#endif

	.file	"crt0.S"

	.globl	_start
	.section .text.start, "ax"
	.p2align 2
	.type	_start,@function
_start:
	; Temporary stack, just for calling memset() and sbrk().
	ldi	sp, #_end+512

	; Clear the bss area. We need to do this before calling any other
	; functions.
	ldi	r1, #__bss_start
	ldi	r3, #__bss_end
	sub	r3, r3, r1
	ldi	r2, #0
	call	memset@pc

	; We use sbrk() to allocate a stack on the heap.
	ldi	r20, #STACK_SIZE
	mov	r1, r20
	call	sbrk@pc
	add	sp, r1, r20	; Stack top is: _end + STACK_SIZE

	; Call _init to invoke static constructors, etc.
	;call	_init@pc
	
	; Call _fini at exit time for static destructors.
	;ldi	r1, #_fini
	;call	atexit@pc

	; Fake argc and argv, and call main().
	ldi	r1, #1		; r1 = argc
	ldi	r2, #argv	; r2 = argv
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

