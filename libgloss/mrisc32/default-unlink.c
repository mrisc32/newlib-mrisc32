/* default-unlink.c -- Default unlink() for MRISC32.
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

typedef int (*unlink_fptr_t)(const char *);

static unlink_fptr_t s_unlink_handler;

void
_set_unlink_handler (unlink_fptr_t f)
{
   s_unlink_handler = f;
}

/*
 * _unlink -- delete a name and possibly the file it refers to.
 */
int
_unlink (const char *pathname)
{
  if (s_unlink_handler)
    return s_unlink_handler (pathname);

  errno = ENOENT;
  return -1;
}

