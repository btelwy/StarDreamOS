// These headers are only typedefs and macros
// So they can be used in a freestanding environment
#include "./kernel.h"

#if !defined(__i386__)
	#error "This code must be compiled with an x86-elf compiler"
#endif

// Initiates terminal by filling it with blank characters and setting default colors
void vgaInit() {
	setCurrentColor(BLACK, WHITE);

	for (currentCol = 0; currentCol < VGA_WIDTH; ++currentCol) {
		for (currentRow = 0; currentRow < VGA_HEIGHT; ++currentRow) {
			setVGAEntry(currentColor, ' ');
		}
	}

	// Reset write position back to start
	setVGAColRow(0, 0);
}

// Prints a single character
void vgaPutChar(char c) {
	switch (c) {
	case '\n': // Newline character
		{
			setVGAColRow(0, currentRow + 1);
			break;
		}

	default: // Printable characters
		{
			setVGAEntry(currentColor, c);
			setVGAColRow(currentCol + 1, currentRow);
			break;
		}
	}

	//After the character has been printed:

	// If past last column
	if (currentCol >= VGA_WIDTH) {
		setVGAColRow(0, currentRow + 1);
	}

	// If past last row
	// Fixme: implement scrolling here
	if (currentRow >= VGA_HEIGHT) {
		setVGAColRow(0, 0);
	}
}

// Prints a string
void vgaPrintStr(const char* str) {
	for (size_t i = 0; str[i] != '\0'; ++i) { vgaPutChar(str[i]); }
}

// Main function
void kernelMain() {
	vgaInit();

	setCurrentColorFG(MAGENTA);
	vgaPrintStr("Hello world!\n");

	setCurrentColorFG(LIGHT_CYAN);
	vgaPrintStr("Never give up. Trust your instincts, Fox!\n");

	// This function does not return
}
