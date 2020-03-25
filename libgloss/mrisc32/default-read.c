/* default-read.c -- Default read() for MRISC32.
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

typedef int (*read_fptr_t)(int, char *, int);

static read_fptr_t s_read_handler;

void
_set_read_handler (read_fptr_t f)
{
   s_read_handler = f;
}

/*
 * _read -- read from a file descriptor.
 */
int
_read (int fd, char *buf, int nbytes)
{
  if (s_read_handler)
    return s_read_handler (fd, buf, nbytes);

  errno = EBADF;
  return -1;
}

