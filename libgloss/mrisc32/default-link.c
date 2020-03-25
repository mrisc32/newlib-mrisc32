/* default-link.c -- Default link() for MRISC32.
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

typedef int (*link_fptr_t)(const char *, const char *);

static link_fptr_t s_link_handler;

void
_set_link_handler (link_fptr_t f)
{
   s_link_handler = f;
}

/*
 * _link -- make a new name for a file.
 */
int
_link (const char *oldpath, const char *newpath)
{
  if (s_link_handler)
    return s_link_handler (oldpath, newpath);

  errno = EPERM;
  return -1;
}

