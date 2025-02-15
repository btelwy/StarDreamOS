OS := stardreamos
HOST := i686-elf
QEMU := qemu-system-i386

SYSROOTDIR := ./sysroot
PREFIX := $(SYSROOTDIR)
INCLUDEDIR := $(PREFIX)/usr/include
LIBDIR := $(PREFIX)/usr/lib

CC := $(HOST)-gcc
CXX := $(HOST)-g++
AR := $(HOST)-ar

C_STD := -std=c23
CXX_STD := -std=c++23
WARNINGS := -Wall -Wextra -Werror -pedantic
OPTIMIZING := -Og
DEBUGGING := -ggdb3
SANITIZING := -fsanitize=address -fsanitize=leak -fsanitize=undefined
OTHER := -ffreestanding --sysroot=$(SYSROOTDIR)

CFLAGS := $(C_STD) $(WARNINGS) $(OPTIMIZING) $(DEBUGGING) $(OTHER)
CXXFLAGS := $(CXX_STD)
LDFLAGS := -nostdlib -lgcc

OUTPUT_ELF = $(SYSROOTDIR)/$(OS).elf
OUTPUT_ISO = $(SYSROOTDIR)/$(OS).iso

include ./StarDreamOS/kernel/Makefile
include ./StarDreamOS/libc/Makefile

.PHONY: all run-elf run-iso burn-iso clean
all:
	$(MAKE) all_k
	$(MAKE) all_c
	grub-mkrescue $(SYSROOTDIR) -o $(OUTPUT_ISO)

# grub-pc-bin is needed to load an ELF file
run-elf:
	$(QEMU) -display curses -kernel $(OUTPUT_ELF)

run-iso:
	$(QEMU) -display curses -cdrom $(OUTPUT_ISO)

# For safety, disk BURN_DISK must be explicitly defined via command line
burn-iso:
	dd if=$(OUTPUT_ISO) of=$(BURN_DISK) bs=1M status=progress

clean:

