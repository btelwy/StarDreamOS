#include <limits.h>
#include <stdbool.h>
#include <stdarg.h>

#include <stdio.h>
#include <string.h>

//TODO: clarify variable names

static bool print(const char* data, size_t length) {
	const unsigned char* bytes = (const unsigned char*) data;

	for (size_t i = 0; i < length; i++)
		if (putc(bytes[i]) == EOF) { return false; }

	return true;
}

int printf(const char* restrict format, ...) {
	va_list params;
	va_start(params, format);

	int written = 0;

	while (*format != '\0') {
		size_t maxRem = INT_MAX - written;

		if (format[0] != '%' || format[1] == '%') {
			if (format[0] == '%') { format++; }

			size_t amount = 1;
			while (format[amount] && format[amount] != '%') { amount++; }

			if (maxRem < amount) {
				// TODO: Set errno to EOVERFLOW
				return EXIT_FAILURE;
			}

			if (!print(format, amount)) { return EXIT_FAILURE; }

			format += amount;
			written += amount;

			continue;
		}

		const char* formatBegunAt = format++;

		if (*format == 'c') {
			format++;
			char c = (char) va_arg(params, int /* char promotes to int */);

			if (!maxRem) {
				// TODO: Set errno to EOVERFLOW
				return EXIT_FAILURE;
			}

			if (!print(&c, sizeof(c))) { return EXIT_FAILURE; }
			written++;
		}
		else if (*format == 's') {
			format++;
			const char* str = va_arg(params, const char*);
			size_t len = strlen(str);

			if (maxRem < len) {
				// TODO: Set errno to EOVERFLOW
				return EXIT_FAILURE;
			}
			if (!print(str, len)) { return EXIT_FAILURE; }

			written += len;
		}
		else {
			format = formatBegunAt;
			size_t len = strlen(format);

			if (maxRem < len) {
				// TODO: Set errno to EOVERFLOW
				return EXIT_FAILURE;
			}
			if (!print(format, len)) { return EXIT_FAILURE; }

			written += len;
			format += len;
		}
	}

	va_end(params);
	return written;
}
