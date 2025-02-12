// These headers are only typedefs and macros
// So they can be used in a freestanding environment
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#if defined(__linux__)
	#warning "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#warning "This code must be compiled with an x86-elf compiler"
#endif

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

// To display text on x86's VGA buffer, write data to this location
volatile uint16_t* vgaBuffer = (uint16_t*)0xB8000;
static const int VGA_WIDTH = 80;
static const int VGA_HEIGHT = 25;
uint8_t vgaColor = 0;

// Start displaying text in the top-left of the screen
int currentCol = 0;
int currentRow = 0;

static inline uint8_t getVGAColor(uint8_t background, uint8_t foreground) {
	// VGA color values have form 0bBBBBFFFF
	// Where B = background color, F = foreground color
	uint8_t colorValue = (background << 4) | (foreground << 0);
	return colorValue;
}

static inline uint16_t getVGAEntry(uint8_t color, unsigned char c) {
	// VGA buffer entries have form 0bBBBBFFFFCCCCCCCC
	// Where B = background color, F = foreground color, C = ASCII value
	uint16_t entryValue = ((uint16_t)color << 8) | ((uint16_t)c << 0);
	return entryValue;
}

static inline uint16_t setVGAColor(uint8_t background, uint8_t foreground) {
	vgaColor = getVGAColor(background, foreground);
	return vgaColor;
}

// Initiates terminal by clearing it
void termInit() {
	setVGAColor(BLACK, WHITE);

	for (int col = 0; col < VGA_WIDTH; ++col) {
		for (int row = 0; row < VGA_HEIGHT; ++row) {
			const size_t index = (VGA_WIDTH * row) + col;
			vgaBuffer[index] = getVGAEntry(vgaColor, ' '); // Set each character to blank
		}
	}
}

// Places a single character onto the screen
void termPutChar(char c) {
	switch (c) {
	case '\n': // Newline character
		{
			currentCol = 0;
			++currentRow;
			break;
		}

	default: // Printable characters
		{
			const size_t index = (VGA_WIDTH * currentRow) + currentCol;
			vgaBuffer[index] = getVGAEntry(vgaColor, c);
			++currentCol;
			break;
		}
	}

	// If past last column
	if (currentCol >= VGA_WIDTH) {
		currentCol = 0;
		++currentRow;
	}

	// If past last row
	if (currentRow >= VGA_HEIGHT) {
		currentCol = 0;
		currentRow = 0;
	}
}

// Prints an entire string onto the screen
void termPrintStr(const char* str) {
	for (size_t i = 0; str[i] != '\0'; ++i)
		termPutChar(str[i]);
}

void kernelMain() {
	termInit();

	setVGAColor(BLACK, WHITE);
	termPrintStr("Hello world!\n");

	setVGAColor(BLACK, LIGHT_BLUE);
	termPrintStr("Never give up.  Trust your instincts, Fox!\n");

	// This function does not return
}
