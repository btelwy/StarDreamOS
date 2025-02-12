.extern kernelMain
.global start

// GRUB Multiboot header data
.set MB_MAGIC, 0x1BADB002							// Kernel location
.set MB_FLAGS, (1 << 0) | (1 << 1) 					// Load modules on page boundaries// provide memory map
.set MB_CHECKSUM, (0 - (MB_MAGIC + MB_FLAGS)) 		// Simple checksum of previous values

// GRUB Multiboot header
.section .multiboot
	.align 4 										// Make sure the following data is aligned on a multiple of 4 bytes
	.long MB_MAGIC
	.long MB_FLAGS
	.long MB_CHECKSUM

// Data initialized to zero on kernel load
.section .bss
.align 16
	stackBottom:
		.skip 4096 									// Allocate 4KB for stack
	stackTop:

// Executable assembly code
.section .text
start:
	mov $stackTop, %esp 							// Set up stack to establish C environment
	call kernelMain
	hang:											// Hang in event of return from kernel_main()
		cli      									// Disable CPU interrupts
		hlt      									// Halt CPU
		jmp hang 									// If that didn't work, try again
