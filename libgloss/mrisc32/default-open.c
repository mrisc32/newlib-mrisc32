/* default-open.c -- Default open() for MRISC32.
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

typedef int (*open_fptr_t)(const char *, int, int);

static open_fptr_t s_open_handler;

void
_set_open_handler (open_fptr_t f)
{
   s_open_handler = f;
}

/*
 * _open -- open and possibly create a file or device.
 */
int
_open (const char *pathname, int flags, int mode)
{
  if (s_open_handler)
    return s_open_handler (pathname, flags, mode);

  errno = EACCES;
  return -1;
}

