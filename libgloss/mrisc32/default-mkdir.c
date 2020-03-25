/* default-mkdir.c -- Default mkdir() for MRISC32.
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

typedef int (*mkdir_fptr_t)(const char *, mode_t);

static mkdir_fptr_t s_mkdir_handler;

void
_set_mkdir_handler (mkdir_fptr_t f)
{
   s_mkdir_handler = f;
}

/*
 * mkdir -- create a directory.
 */
int
mkdir (const char *pathname, mode_t mode)
{
  if (s_mkdir_handler)
    return s_mkdir_handler (pathname, mode);

  errno = EACCES;
  return -1;
}

