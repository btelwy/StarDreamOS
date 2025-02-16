# Function epilogues
.section .init
	/* GCC will put crtend.o's .init section here */
	popl %ebp
	ret

.section .fini
	/* GCC will put crtend.o's .fini section here */
	popl %ebp
	ret
