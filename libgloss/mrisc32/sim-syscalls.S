/* sim-syscalls.S -- Syscall implementations for the MRISC32 simulator.
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

	.file	"sim-syscalls.S"

	/* Simulator syscall routine addresses.  */
	SYSCALL_EXIT          = 0xffff0000+4*0
	SYSCALL_PUTCHAR       = 0xffff0000+4*1
	SYSCALL_GETCHAR       = 0xffff0000+4*2
	SYSCALL_CLOSE         = 0xffff0000+4*3
	SYSCALL_FSTAT         = 0xffff0000+4*4
	SYSCALL_ISATTY        = 0xffff0000+4*5
	SYSCALL_LINK          = 0xffff0000+4*6
	SYSCALL_LSEEK         = 0xffff0000+4*7
	SYSCALL_MKDIR         = 0xffff0000+4*8
	SYSCALL_OPEN          = 0xffff0000+4*9
	SYSCALL_READ          = 0xffff0000+4*10
	SYSCALL_STAT          = 0xffff0000+4*11
	SYSCALL_UNLINK        = 0xffff0000+4*12
	SYSCALL_WRITE         = 0xffff0000+4*13
	SYSCALL_GETTIMEMICROS = 0xffff0000+4*14


	/* A convenience macro for emitting simulator syscalls.  */
	.macro	EMIT_SYSCALL name, addr
	.globl	\name
	.type	\name,@function
\name:
	j	z, #\addr
	.size	\name,.-\name
	.endm


	.section .text
	.p2align 2

	/* These syscalls map 1:1 to simulator calls.  */
	EMIT_SYSCALL	_exit,   SYSCALL_EXIT
	EMIT_SYSCALL	_close,  SYSCALL_CLOSE
	EMIT_SYSCALL	_fstat,  SYSCALL_FSTAT
	EMIT_SYSCALL	_isatty, SYSCALL_ISATTY
	EMIT_SYSCALL	_link,   SYSCALL_LINK
	EMIT_SYSCALL	_lseek,  SYSCALL_LSEEK
	EMIT_SYSCALL	_mkdir,  SYSCALL_MKDIR
	EMIT_SYSCALL	_open,   SYSCALL_OPEN
	EMIT_SYSCALL	_read,   SYSCALL_READ
	EMIT_SYSCALL	_stat,   SYSCALL_STAT
	EMIT_SYSCALL	_unlink, SYSCALL_UNLINK
	EMIT_SYSCALL	_write,  SYSCALL_WRITE

	/* _mrisc32_gettimemicros() is used to implement _gettimeofday().  */
	EMIT_SYSCALL	_mrisc32_gettimemicros, SYSCALL_GETTIMEMICROS

