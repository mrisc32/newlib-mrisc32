/* mrisc32-write.c -- Implemenetation of write() for MRISC32.
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


extern int _mrisc32_outbyte (char x);


/*
 * _write -- write to a file descriptor.
 */
int
_write (int fd, const char *buf, int nbytes)
{
  int i;

  if (fd != STDOUT_FILENO && fd != STDERR_FILENO) {
    errno = EBADF;
    return -1;
  }

  for (i = 0; i < nbytes; i++) {
    if (*(buf + i) == '\n') {
      _mrisc32_outbyte ('\r');
    }
    _mrisc32_outbyte (*(buf + i));
  }

  return nbytes;
}

