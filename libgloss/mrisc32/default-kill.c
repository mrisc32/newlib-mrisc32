/* default-kill.c -- Default kill() for MRISC32.
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

typedef int (*kill_fptr_t)(int, int);

static kill_fptr_t s_kill_handler;

void
_set_kill_handler (kill_fptr_t f)
{
   s_kill_handler = f;
}

/*
 * _kill -- send signal to a process.
 */
int
_kill (int pid, int sig)
{
  if (s_kill_handler)
    return s_kill_handler (pid, sig);

  errno = EPERM;
  return -1;
}
