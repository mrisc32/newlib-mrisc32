/* default-gettimemicros.c -- Default gettimemicros().
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

typedef unsigned long long (*gettimemicros_fptr_t)(void);

static gettimemicros_fptr_t s_gettimemicros_handler;

void
_set_gettimemicros_handler (gettimemicros_fptr_t f)
{
   s_gettimemicros_handler = f;
}

/*
 * _gettimemicros -- get the current time.
 */
unsigned long long
_gettimemicros (void)
{
  if (s_gettimemicros_handler)
    return s_gettimemicros_handler ();

  /* We just increment a static counter to simulate that 1 ms has passed
   * between each call (that should at least prevent busy waiting loops from
   * being stuck forever).  */
  static unsigned long long s_time = 0;
  s_time += 1000ULL;
  return s_time;
}

