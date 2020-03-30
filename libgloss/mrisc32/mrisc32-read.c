/* mrisc32-read.c -- Implementation of read() for MRISC32.
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


extern char _mrisc32_inbyte (void);


/*
 * _read -- read from a file descriptor.
 */
int
_read (int fd, char *buf, int nbytes)
{
  int i;

  if (fd != STDIN_FILENO) {
    errno = EBADF;
    return -1;
  }

  for (i = 0; i < nbytes; i++) {
    *(buf + i) = _mrisc32_inbyte();
    if ((*(buf + i) == '\n') || (*(buf + i) == '\r')) {
      i++;
      break;
    }
  }

  return i;
}

