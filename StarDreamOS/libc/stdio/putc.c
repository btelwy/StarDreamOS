#include <stdio.h>

#if defined(__is_libk)
#include <kernel/tty.h>
#endif

int putc(int ic) {
#if defined(__is_libk)
	char c = (char) ic;
	terminal_put_data(&c, sizeof(c));
#else
	// TODO: Implement stdio and the write system call.
#endif
	return ic;
}
