#ifndef _KERNEL_TTY_H_
#define _KERNEL_TTY_H_ 1

#include <stddef.h>
#include <stdint.h>

// Note: figure out how to make these function signatures architecture-independent
// Each platform should implement these functions,
// Different platforms may in the future require different types for the paramaters, e.g., uint8_t vs uint32_t
// Or some may be best with different attributes or specifiers, like inlining

void terminal_init(void);

uint8_t terminal_set_color(uint8_t color);
int terminal_set_position(size_t col, size_t row);
int terminal_set_entry_at(unsigned char uc, uint8_t color, size_t col, size_t row);
void terminal_set_this_entry(unsigned char uc, uint8_t color);

void terminal_put_char(char c);
void terminal_put_data(const char* data, size_t size);
void terminal_put_string(const char* str);

#endif
