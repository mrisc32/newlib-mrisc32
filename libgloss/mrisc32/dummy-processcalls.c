/* dummy-syscalls.c -- Dummy process related syscalls for MRISC32.
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


/*
 * _execve - execute a program.
 */
int
_execve(const char *name, char * const *argv, char * const *env)
{
  (void)name;
  (void)argv;
  (void)env;
  return -1;
}

/*
 * _fork - create a child process.
 */
int
_fork()
{
  errno = ENOSYS;
  return -1;
}

/*
 * _getpid -- get process ID.
 */
int
_getpid ()
{
  return __MYPID;
}

/*
 * _kill -- send signal to a process.
 */
int
_kill (int pid, int sig)
{
  (void)pid;
  (void)sig;
  errno = EPERM;
  return -1;
}

