/* mrisc32-gettimeofday.c -- Dummy syscalls for MRISC32.
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
#include <sys/time.h>


/*
 * _gettimeofday - get the current time.
 */
int
_gettimeofday (struct timeval *ptimeval, void *ptimezone)
{
  if (ptimeval) {
    const unsigned long long time_us = _mrisc32_gettimemicros ();
    ptimeval->tv_sec = time_us / 1000000ULL;
    ptimeval->tv_usec = time_us - ptimeval->tv_sec * 1000000ULL;
  }

  (void)ptimezone;

  return 0;
}

