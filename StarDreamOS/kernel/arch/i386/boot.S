# Constants for the Multiboot header
.set ALIGN_BIT,    1<<0             		# Align loaded modules on page boundaries
.set MEMINFO_BIT,  1<<1             		# Provide memory map
.set FLAGS,    ALIGN_BIT | MEMINFO_BIT		# "Flags" field of header
.set MAGIC,    0x1BADB002 					# Location of header
.set CHECKSUM, -(MAGIC + FLAGS)				# Verifies Multiboot mode

# Header conforming to version 1 of the Multiboot Standard
.section .multiboot
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

# The kernel entry point
.section .text
.global _start
.type _start, @function
_start:
	movl $stack_top, %esp

	# Call global constructors
	call _init

	# Transfer control to main kernel
	call kernel_main

	# Hang if kernel_main (unexpectedly) returns
	cli
1:
	hlt
	jmp 1b
.size _start, . - _start 					# Calculate size of _start function
