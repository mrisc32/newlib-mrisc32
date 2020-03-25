/* crt0.S -- startup file for MRISC32
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

	.file	"crt0.S"
	.globl	_start
	.text
	.type	_start,@function
_start:
	; Initialize the stack.
	; TODO(m): How to do this in the generic case?
	ldi	sp, #_stack

	; zero the bss area
	ldi	s1, #__bss_start__
	ldi	s2, #__bss_end__
	sub	s2, s1, s2
	call	memset

	; Call _init to invoke static constructors, etc.
	;call	_init
	
	; Call _fini at exit time for static destructors.
	;ldi	s1, #_fini
	;call	atexit

	; Fake argc and argv, and call main().
	ldi	s1, #1		; s1 = argc
	ldi	s2, #argv	; s2 = argv
	call	main

	; Call exit().
	ldhi	s2, #exit@hi
	j	s2, #exit@lo

	.size	_start,.-_start


	.section	.rodata
	.p2align	2
argv:
	.word	argv_data

argv_data:
	.asciz	"program"
	.p2align	2

