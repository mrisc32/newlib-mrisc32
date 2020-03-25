/* default-exit.c --Default exit() for MRISC32.
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

#include <sys/types.h>
#include <sys/unistd.h>
#include "glue.h"

typedef void (*exit_fptr_t)(int);

static exit_fptr_t s_exit_handler;

void
_set_exit_handler (exit_fptr_t f)
{
   s_exit_handler = f;
}

/*
 * _exit -- terminate calling process.
 */
void
_exit (int status)
{
  if (s_exit_handler)
    s_exit_handler (status);

  while (1) {
  }
}

