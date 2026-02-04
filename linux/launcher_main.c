/*
 * Launcher for oxchat_app_main: sets FD limit (ulimit) and GDK_BACKEND=x11,
 * then exec's the real app (oxchat_app_main.bin). Users run this binary;
 * no script required.
 */
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/resource.h>

#define REAL_BIN "oxchat_app_main.bin"
#define FD_LIMIT 65536

static char *dirname_copy(const char *path) {
  char *buf = strdup(path);
  if (!buf) return NULL;
  char *last = strrchr(buf, '/');
  if (last && last != buf)
    *last = '\0';
  else if (last == buf)
    buf[1] = '\0';
  return buf;
}

int main(int argc, char **argv) {
  struct rlimit rl;
  rl.rlim_cur = FD_LIMIT;
  rl.rlim_max = FD_LIMIT;
  if (setrlimit(RLIMIT_NOFILE, &rl) != 0) {
    /* Non-fatal: continue without raising FD limit */
  }

  setenv("GDK_BACKEND", "x11", 0);

  char *exe = realpath("/proc/self/exe", NULL);
  if (!exe) {
    if (argv[0] && strchr(argv[0], '/'))
      exe = realpath(argv[0], NULL);
    if (!exe)
      exe = strdup(argv[0] ? argv[0] : ".");
    if (!exe) { perror("strdup"); return 127; }
  }
  char *dir = dirname_copy(exe);
  free(exe);
  if (!dir) { perror("strdup"); return 127; }

  size_t dlen = strlen(dir);
  size_t blen = strlen(REAL_BIN);
  char *bin_path = malloc(dlen + 1 + blen + 1);
  if (!bin_path) { free(dir); return 127; }
  snprintf(bin_path, dlen + 1 + blen + 1, "%s/%s", dir, REAL_BIN);

  if (chdir(dir) != 0) {
    perror("chdir");
    free(dir);
    free(bin_path);
    return 126;
  }
  free(dir);

  argv[0] = bin_path;
  execv(bin_path, argv);
  perror(bin_path);
  free(bin_path);
  return 126;
}
