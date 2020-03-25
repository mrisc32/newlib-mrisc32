/* default-getpid.c -- Default getpid() for MRISC32.
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

#include "glue.h"

typedef int (*getpid_fptr_t)(void);

static getpid_fptr_t s_getpid_handler;

void
_set_getpid_handler (getpid_fptr_t f)
{
   s_getpid_handler = f;
}

/*
 * _getpid -- get process ID.
 */
int
_getpid (void)
{
  if (s_getpid_handler)
    return s_getpid_handler ();

  return __MYPID;
}
