/* mrisc32-sbrk.c -- Implementation of sbrk() for MRISC32.
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

#include <sys/errno.h>
#include <sys/types.h>
#include "glue.h"

#ifndef HEAP_SIZE
#define HEAP_SIZE (256 * 1024 * 1024)
#endif

static
char* align_ptr (char* ptr)
{
  static const unsigned long ALIGNMENT = 8;
  return (char *) ((((unsigned long)ptr) + ALIGNMENT-1) & ~(ALIGNMENT-1));
}


/*
 * _sbrk -- changes heap size size. Get nbytes more RAM. We just increment a
 *          pointer in what's left of memory on the board.
 */
caddr_t
_sbrk (size_t nbytes)
{
  char* HEAP_START = (char *)&_end;
  char* HEAP_END = ((char *)&_end) + HEAP_SIZE;

  static char* s_heap_ptr = NULL;

  /* Initialize the heap pointer if this is the first call to _sbrk.  */
  if (s_heap_ptr == NULL)
    {
      s_heap_ptr = align_ptr (HEAP_START);
    }

  /* Allocate.  */
  if ((s_heap_ptr + nbytes) < HEAP_END)
    {
      char* allocated_ptr = s_heap_ptr;
      s_heap_ptr = align_ptr (s_heap_ptr + nbytes);
      return (caddr_t) allocated_ptr;
    }

  /* Out of memory.  */
  errno = ENOMEM;
  return (caddr_t) -1;
}

