#ifndef _STDIO_H_
#define _STDIO_H_ 1

#include <sys/cdefs.h>

#define EOF (-1)

#ifdef __cplusplus
extern "C" {
#endif

int printf(const char* __restrict, ...);
int putc(int);
int puts(const char*);

#ifdef __cplusplus
}
#endif

#endif
