/* default-write.c -- Default write() for MRISC32.
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
#include <sys/unistd.h>
#include "glue.h"

typedef int (*write_fptr_t)(int, const char *, int);

static write_fptr_t s_write_handler;

void
_set_write_handler (write_fptr_t f)
{
   s_write_handler = f;
}

/*
 * _write -- write to a file descriptor.
 */
int
_write (int fd, const char *buf, int nbytes)
{
  if (s_write_handler)
    return s_write_handler (fd, buf, nbytes);

  errno = EBADF;
  return -1;
}

