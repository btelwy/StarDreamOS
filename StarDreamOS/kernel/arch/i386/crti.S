# Function prologues
# _init is called from ./boot.S
.section .init
.global _init
.type _init, @function
_init:
	pushl %ebp
	movl %esp, %ebp
	/* GCC will put crtbegin.o's .init section here */

.section .fini
.global _fini
.type _fini, @function
_fini:
	pushl %ebp
	movl %esp, %ebp
	/* GCC will put crtbegin.o's .fini section here */
