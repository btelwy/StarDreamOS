// GRUB Multiboot header
.section .multiboot_header
.set MB_MAGIC, 0x1BADB002							// Kernel location
.set MB_FLAGS, (1 << 0) | (1 << 1) 					// Bit 0, load modules on page boundaries; bit 1, provide memory map
.set MB_CHECKSUM, -(MB_MAGIC + MB_FLAGS)
.align 4
	.long MB_MAGIC
	.long MB_FLAGS
	.long MB_CHECKSUM

// Data initialized to zero on kernel load
.section .bss
.align 0x10
	stackBottom:
		.skip 0x1000 								// Allocate 4 KB for stack
	stackTop:

// Executable assembly code
.section .text
.global _start
.type _start, @function
_start:
	mov $stackTop, %esp 							// Set up stack to establish C environment
	call kernelMain
	hang:											// Hang in event of return from kernel_main()
		cli      									// Disable CPU interrupts
		hlt      									// Halt CPU
		jmp hang 									// If that didn't work, try again

.size _start, . - _start 							// For call tracing
