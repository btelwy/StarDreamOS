# Header conforming to version 1 of the Multiboot Standard
.section .multiboot
.set MAGIC, 		0x1BADB002 					# For the "magic" field of header, the kernel location
.set ALIGN_BIT, 	1<<0             			# Flag: align loaded modules on page boundaries
.set MEMINFO_BIT, 	1<<1             			# Flag: provide memory map
.set FLAGS,    		ALIGN_BIT | MEMINFO_BIT		# For the "flags" field of header
.set CHECKSUM, 		-(MAGIC + FLAGS)			# For the "checksum" field of header

.align 4
	.long MAGIC
	.long FLAGS
	.long CHECKSUM

# Reserve a stack for initial thread
.section .bss
.align 0x10
	stack_bottom:
		.skip 0x4000 							# 16 KiB
	stack_top:

# Kernel entry point
.section .text
.global _start
.type _start, @function
_start:
	movl $stack_top, %esp

	# Call global constructors in ./crti.S
	call _init

	# Transfer control to kernel.c
	call kernel_main

	# Hang if kernel_main (unexpectedly) returns
	cli
hang:
	hlt
	jmp hang

.size _start, . - _start 					# Calculate size of _start function
