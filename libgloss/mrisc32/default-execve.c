/* default-execve.c -- Default execve() for MRISC32.
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

typedef int (*execve_fptr_t)(const char *, char * const *, char * const *);

static execve_fptr_t s_execve_handler;

void
_set_execve_handler (execve_fptr_t f)
{
   s_execve_handler = f;
}

/*
 * _execve - execute a program.
 */
int
_execve(const char *name, char * const *argv, char * const *env)
{
  if (s_execve_handler)
    return s_execve_handler (name, argv, env);

  return -1;
}

