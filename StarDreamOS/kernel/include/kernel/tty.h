#ifndef _KERNEL_TTY_H_
#define _KERNEL_TTY_H_ 1

#include <stddef.h>

void terminal_initialize(void);
void terminal_put_char(char c);
void terminal_write(const char* data, size_t size);
void terminal_write_str(const char* data);

#endif
