/* default-fstat.c -- Default fstat() for MRISC32.
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

#include <string.h>
#include <sys/errno.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/unistd.h>
#include "glue.h"

typedef int (*fstat_fptr_t)(int, struct stat *);

static fstat_fptr_t s_fstat_handler;

void
_set_fstat_handler (fstat_fptr_t f)
{
   s_fstat_handler = f;
}

/*
 * _fstat -- get file stats.
 */
int
_fstat (int fd, struct stat *buf)
{
  if (s_fstat_handler)
    return s_fstat_handler (fd, buf);

  if (fd == STDOUT_FILENO || fd == STDERR_FILENO)
    {
      memset(buf, 0, sizeof(struct stat));
      buf->st_mode = S_IFCHR;
      buf->st_blksize = 0;
      return 0;
    }
  errno = EBADF;
  return -1;
}

