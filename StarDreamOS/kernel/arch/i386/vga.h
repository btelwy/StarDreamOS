#ifndef ARCH_I386_VGA_H_
#define ARCH_I386_VGA_H_ 1

#include <stdint.h>

enum vga_color {
	VGA_COLOR_BLACK = 0b0000,
	VGA_COLOR_BLUE = 0b0001,
	VGA_COLOR_GREEN = 0b0010,
	VGA_COLOR_CYAN = 0b0011,
	VGA_COLOR_RED = 0b0100,
	VGA_COLOR_MAGENTA = 0b0101,
	VGA_COLOR_BROWN = 0b0110,
	VGA_COLOR_LIGHT_GRAY = 0b0111,
	VGA_COLOR_DARK_GRAY = 0b1000,
	VGA_COLOR_LIGHT_BLUE = 0b1001,
	VGA_COLOR_LIGHT_GREEN = 0b1010,
	VGA_COLOR_LIGHT_CYAN = 0b1011,
	VGA_COLOR_LIGHT_RED = 0b1100,
	VGA_COLOR_LIGHT_MAGENTA = 0b1101,
	VGA_COLOR_LIGHT_BROWN = 0b1110,
	VGA_COLOR_WHITE = 0b1111
};

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) {
	return bg << 4 | fg;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color) {
	return (uint16_t) color << 8 | (uint16_t) uc;
}

#endif
