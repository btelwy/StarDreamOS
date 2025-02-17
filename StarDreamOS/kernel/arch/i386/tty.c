#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include <string.h>

#include <kernel/tty.h>

#include "./vga.h"

static uint16_t* const VGA_MEMORY = (uint16_t*) i386_VGA_WRITE_ADDR;
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

static size_t terminalRow;
static size_t terminalColumn;
static uint8_t terminalColor;
static uint16_t* terminalBuf;

void terminal_init() {
	terminalRow = 0;
	terminalColumn = 0;
	terminalColor = calc_vga_color(VGA_COLOR_LIGHT_GRAY, VGA_COLOR_BLACK);
	terminalBuf = VGA_MEMORY;

	for (size_t col = 0; col < VGA_WIDTH; col++) {
		for (size_t row = 0; row < VGA_HEIGHT; row++) {
			const size_t index = row * VGA_WIDTH + col;
			terminalBuf[index] = calc_vga_entry(' ', terminalColor);
		}
	}
}

uint8_t terminal_set_color(uint8_t color) {
	terminalColor = color;

	return terminalColor;
}

int terminal_set_position(size_t col, size_t row) {
	if (col >= VGA_WIDTH || row >= VGA_HEIGHT)
		return EXIT_FAILURE;

	terminalColumn = col;
	terminalRow = row;

	return EXIT_SUCCESS;
}

// Does not change values of terminalColumn, terminalRow, and terminalColor
int terminal_set_entry_at(unsigned char uc, uint8_t color, size_t col, size_t row) {
	if (col >= VGA_WIDTH || row >= VGA_HEIGHT)
		return EXIT_FAILURE;

	const size_t index = row * VGA_WIDTH + col;
	terminalBuf[index] = calc_vga_entry(uc, color);

	return EXIT_SUCCESS;
}

// This is convenient, but this function wrapper may cause unnecessary overhead after many calls?
// It does not look at terminal_sent_entry_at()'s exit code because out-of-bounds input is not possible here
void terminal_set_this_entry(unsigned char uc, uint8_t color) {
	terminal_set_entry_at(uc, color, terminalColumn, terminalRow);
	return;
}

void terminal_put_char(char c) {
	unsigned char uc = c;

	switch (uc) {
		// TODO: add cases for other non-printable characters as necessary
		case '\n':
			terminalColumn = 0;
			++terminalRow;
			break;

		// Printable characters
		default:
			terminal_set_this_entry(uc, terminalColor);
			++terminalColumn;
			break;
	}

	/* After printing that character, check postcondition that terminal width, height bounds still hold */
	// If past the last column, go to new line
	if (terminalColumn == VGA_WIDTH) {
		terminalColumn = 0;
		++terminalRow;
	}

	// If past the last row, scroll the terminal by one line
	if (terminalRow == VGA_HEIGHT) {
		terminalRow = 0; // Placeholder
		// TODO: implement scrolling here
	}
	// Note: if vertical tab is implemented, these checks must be reconsidered

	return;
}

void terminal_put_data(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++) {
		terminal_put_char(data[i]);
	}
	return;
}

void terminal_put_string(const char* str) {
	terminal_put_data(str, strlen(str));
	return;
}
