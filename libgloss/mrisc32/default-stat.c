/* default-stat.c -- Default stat() for MRISC32.
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
#include <sys/stat.h>
#include <sys/unistd.h>
#include "glue.h"

typedef int (*stat_fptr_t)(const char *, struct stat *);

static stat_fptr_t s_stat_handler;

void
_set_stat_handler (stat_fptr_t f)
{
   s_stat_handler = f;
}

/*
 * _stat -- get file status.
 */
int
_stat (const char *path, struct stat *buf)
{
  if (s_stat_handler)
    return s_stat_handler (path, buf);

  errno = ENOENT;
  return -1;
}

