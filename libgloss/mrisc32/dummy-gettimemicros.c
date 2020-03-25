/* dummy-gettimemicros.c -- Dummy implementation _mrisc32_gettimemicros.
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

/*
 * _mrisc32_gettimemicros -- get the current time. We just increment a static
 *                           counter to simulate that 1 ms has passed between
 *                           each call (that should at least prevent busy
 *                           waiting loops from being stuck forever).
 */
unsigned long long
_mrisc32_gettimemicros ()
{
  static unsigned long long s_time = 0;
  s_time += 1000ULL;
  return s_time;
}

