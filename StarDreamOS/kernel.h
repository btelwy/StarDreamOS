#ifndef _KERNEL_H_
#define _KERNEL_H_ 1

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum exitCodes {
	EXIT_SUCCESS = 0,
	EXIT_FAILURE = 1
};

enum vgaColors {
	BLACK = 0b0000,
	BLUE = 0b0001,
	GREEN = 0b0011,
	CYAN = 0b0011,
	RED = 0b0100,
	MAGENTA = 0b0101,
	BROWN = 0b0110,
	LIGHT_GRAY = 0b0111,
	DARK_GRAY = 0b1000,
	LIGHT_BLUE = 0b1001,
	LIGHT_GREEN = 0b1010,
	LIGHT_CYAN = 0b1011,
	LIGHT_RED = 0b1100,
	LIGHT_MAGENTA = 0b1101,
	LIGHT_BROWN = 0b1110,
	WHITE = 0b1111
};

#define X86_VGA_BUFFER_WRITE_ADDR 0xB8000

static uint16_t* vgaBuf = (uint16_t*)X86_VGA_BUFFER_WRITE_ADDR;
static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

// The non-inline functions
void termInit();
void termPutChar(char c);
void termPrintStr(const char* str);
void kernelMain();

size_t currentCol;
size_t currentRow;
uint8_t currentColor;

//The inline functions:
// ----------------------------------------------

// Set both background and foreground VGA colors
static inline uint8_t setCurrentColor(uint8_t background, uint8_t foreground) {
	// VGA color values have form 0bBBBBFFFF
	currentColor = (background << 4) | (foreground << 0);
	return currentColor;
}

// Set background VGA color, leaving the foreground unchanged
static inline uint8_t setCurrentColorBG(uint8_t background) {
	uint8_t foreground = currentColor & 0b00001111;
	currentColor = (background << 4) | (foreground << 0);
	return currentColor;
}

// Set foreground VGA color, leaving the background unchanged
static inline uint8_t setCurrentColorFG(uint8_t foreground) {
	uint8_t background = currentColor & 0b11110000;
	currentColor = (background << 4) | (foreground << 0);
	return currentColor;
}

static inline size_t getVGABufIndex() {
	return (VGA_WIDTH * currentRow) + currentCol;
}

static inline uint16_t setVGAEntry(uint8_t colorVal, char c) {
	// VGA buffer entries have form 0bBBBBFFFFCCCCCCCC
	// Where B = background color, F = foreground color, C = ASCII value
	uint16_t entryVal = ((uint16_t)colorVal << 8) | ((uint16_t)c << 0);
	vgaBuf[getVGABufIndex()] = entryVal;
	return entryVal;
}

static inline int setVGAColRow(size_t newCol, size_t newRow) {
	if (newCol >= VGA_WIDTH || newRow >= VGA_HEIGHT) { return EXIT_FAILURE; }

	currentCol = newCol;
	currentRow = newRow;
	return EXIT_SUCCESS;
}

#endif
