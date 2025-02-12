// These headers are only typedefs and macros
// So they can be used in a freestanding environment
#include <stddef.h>
#include <stdint.h>

// Basic checks to ensure correct use of x86-elf cross-compiler correctly
#if defined(__linux__)
	#warning "This code must be compiled with a cross-compiler"
#elif !defined(__i386__)
	#warning "This code must be compiled with an x86-elf compiler"
#endif

// To display text on x86's VGA buffer, write data to this location
volatile uint16_t vgaBuffer = (uint16_t*)0xB8000;
// By default, the VGA textmode buffer has a size of 80x25 characters
const int VGA_COLS = 80;
const int VGA_ROWS = 25;

// Start displaying text in the top-left of the screen
int currentCol = 0;
int currentRow = 0;
uint8_t currentColor = 0x0F; // Black background, white foreground

// Initiates terminal by clearing it
void termInit() {
	// Clear the textmode buffer
	for (int col = 0; col < VGA_COLS; ++col)
	{
		for (int row = 0; row < VGA_ROWS; ++row)
		{
			// Find index into VGA textmode buffer for current character
			const size_t index = (VGA_COLS * row) + col;
			// VGA buffer entries take binary form BBBBFFFFCCCCCCCC
			// Where B is background color, F is foreground color, C is ASCII character
			vgaBuffer[index] = ((uint16_t)currentColor << 8) | ' '; // Set each character to blank
		}
	}
}

// Places a single character onto the screen
void term_putc(char c) {
	switch (c) {
	case '\n': // Newline characters should return column to 0 and increment row
		{
			currentCol = 0;
			++currentRow;
			break;
		}

	default: // Printable characters are displayed and then column is incremented
		{
			const size_t index = (VGA_COLS * currentRow) + currentCol;
			vgaBuffer[index] = ((uint16_t)currentColor << 8) | c;
			++currentCol;
			break;
		}
	}

	// If past last column
	if (currentCol >= VGA_COLS) {
		currentCol = 0;
		++currentRow;
	}

	// If past last row
	if (currentRow >= VGA_ROWS) {
		currentCol = 0;
		currentRow = 0;
	}
}

// Prints an entire string onto the screen
void termPrint(const char* str) {
	for (size_t i = 0; str[i] != '\0'; ++i)
		term_putc(str[i]);
}

void kernelMain() {
	termInit();

	termPrint("Hello, world!\n");
	termPrint("Trust your instincts, Fox!\n");
}
