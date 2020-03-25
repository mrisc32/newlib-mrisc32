/* default-close.c -- Default close() for MRISC32.
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

#include <sys/types.h>
#include "glue.h"

typedef int (*close_fptr_t)(int);

static close_fptr_t s_close_handler;

void
_set_close_handler (close_fptr_t f)
{
   s_close_handler = f;
}

/*
 * _close -- close a file descriptor.
 */
int
_close (int fd)
{
  if (s_close_handler)
    return s_close_handler (fd);

  return -1;
}

