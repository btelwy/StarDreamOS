ENTRY(_start)

SECTIONS {
	/* Start at an offset of 2 MB */
	. = 0x200000;

	.text ALIGN(0x1000): {
		*(.multiboot_header)
		*(.text)
	}

	.rodata ALIGN(0x1000): {
		*(.rodata)
	}

	.data ALIGN(0x1000): {
		*(.data)
	}

	/* COMMON is a keyword for uninitialized data */
	.bss ALIGN(0x1000): {
		*(COMMON)
		*(.bss)
	}
}
