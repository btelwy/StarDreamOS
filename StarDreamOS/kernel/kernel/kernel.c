#include <stdio.h>

#include <kernel/tty.h>

void kernel_main() {
	terminal_init();

	terminal_put_string("Never give up.  Trust your instincts, Fox!\n");
	terminal_put_string("Do a barrel roll!\n");
}
