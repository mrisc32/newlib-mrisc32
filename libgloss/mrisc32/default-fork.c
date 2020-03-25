/* default-fork.c -- Default fork() for MRISC32.
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

typedef int (*fork_fptr_t)(void);

static fork_fptr_t s_fork_handler;

void
_set_fork_handler (fork_fptr_t f)
{
   s_fork_handler = f;
}

/*
 * _fork - create a child process.
 */
int
_fork()
{
  if (s_fork_handler)
    return s_fork_handler ();

  errno = ENOSYS;
  return -1;
}
