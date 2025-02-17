#ifndef ARCH_I386_VGA_H_
#define ARCH_I386_VGA_H_ 1

#include <stdint.h>

#define i386_VGA_WRITE_ADDR 0xB8000

enum vgaColor {
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

// Note: these functions can't be used with only <kernel/tty.h>
inline uint8_t calc_vga_color(enum vgaColor fg, enum vgaColor bg) {
	return (bg << 4 | fg);
}

inline uint16_t calc_vga_entry(unsigned char uc, uint8_t color) {
	return ((uint16_t) color << 8 | (uint16_t) uc);
}

#endif
