/* dummy-syscalls.c -- Dummy syscalls for MRISC32.
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

#include <string.h>
#include <sys/errno.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/unistd.h>
#include "glue.h"


/*
 * _close -- close a file descriptor.
 */
int
_close (int fd)
{
  (void)fd;
  return -1;
}

/*
 * _exit -- terminate calling process.
 */
void
_exit (int status)
{
  (void)status;
  while (1) {
  }
}

/*
 * _fstat -- get file stats.
 */
int
_fstat (int fd, struct stat *buf)
{
  if (fd == STDOUT_FILENO || fd == STDERR_FILENO)
    {
      memset(buf, 0, sizeof(struct stat));
      buf->st_mode = S_IFCHR;
      buf->st_blksize = 0;
      return 0;
    }
  errno = EBADF;
  return -1;
}

/*
 * _isatty -- test whether a file descriptor refers to a terminal.
 */
int
_isatty (int fd)
{
  return fd == STDOUT_FILENO || fd == STDERR_FILENO;
}

/*
 * _link -- make a new name for a file.
 */
int
_link (const char *oldpath, const char *newpath)
{
  (void)oldpath;
  (void)newpath;
  errno = EPERM;
  return -1;
}

/*
 * _lseek -- reposition read/write file offset.
 */
_off_t
_lseek (int fd, _off_t offset, int whence)
{
  (void)fd;
  (void)offset;
  (void)whence;
  errno = EBADF;
  return (off_t)-1;
}

/*
 * _mkdir -- create a directory.
 */
int
_mkdir (const char *pathname, mode_t mode)
{
  (void)pathname;
  (void)mode;
  errno = EACCES;
  return -1;
}

/*
 * _open -- open and possibly create a file or device.
 */
int
_open (const char *pathname, int flags, int mode)
{
  (void)pathname;
  (void)flags;
  (void)mode;
  errno = EACCES;
  return -1;
}

/*
 * _read -- read from a file descriptor.
 */
int
_read (int fd, char *buf, int nbytes)
{
  (void)fd;
  (void)buf;
  (void)nbytes;
  errno = EBADF;
  return -1;
}

/*
 * _stat -- get file status.
 */
int
_stat (const char *path, struct stat *buf)
{
  (void)path;
  (void)buf;
  errno = ENOENT;
  return -1;
}

/*
 * _unlink -- delete a name and possibly the file it refers to.
 */
int
_unlink (const char *pathname)
{
  (void)pathname;
  errno = ENOENT;
  return -1;
}

/*
 * _write -- write to a file descriptor.
 */
int
_write (int fd, const char *buf, int nbytes)
{
  (void)fd;
  (void)buf;
  (void)nbytes;
  errno = EBADF;
  return -1;
}

