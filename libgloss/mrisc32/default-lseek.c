/* default-lseek.c -- Default lseek() for MRISC32.
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
#include <sys/unistd.h>
#include "glue.h"

typedef _off_t (*lseek_fptr_t)(int, _off_t, int);

static lseek_fptr_t s_lseek_handler;

void
_set_lseek_handler (lseek_fptr_t f)
{
   s_lseek_handler = f;
}

/*
 * _lseek -- reposition read/write file offset.
 */
_off_t
_lseek (int fd, _off_t offset, int whence)
{
  if (s_lseek_handler)
    return s_lseek_handler (fd, offset, whence);

  errno = EBADF;
  return (off_t)-1;
}

