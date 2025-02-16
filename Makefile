OS := stardreamos
HOST_TARGET := i686-elf
HOST_ARCH := i386
QEMU := qemu-system-i386

SRC_DIR := ~/projects/StarDreamOS/StarDreamOS
BUILD_DIR := ~/projects/StarDreamOS/build
SYSROOT_DIR := ~/projects/StarDreamOS/sysroot

BOOT_DIR := $(SYSROOT_DIR)/boot
GRUB_DIR := $(BOOT_DIR)/grub
OUTPUT_ELF = $(BOOT_DIR)/$(OS).elf
OUTPUT_ISO = $(BOOT_DIR)/$(OS).iso

PREFIX := $(SYSROOT_DIR)/usr
INCLUDE_DIR := $(PREFIX)/include
LIB_DIR := $(PREFIX)/lib

BUILD_DIR_K := $(BUILD_DIR)/kernel
BUILD_DIR_ARCH_K := $(BUILD_DIR_K)/arch/$(HOST_ARCH)
BUILD_DIR_KERNEL_K := $(BUILD_DIR_K)/kernel
BUILD_DIR_C := $(BUILD_DIR)/libc
BUILD_DIR_ARCH_C := $(BUILD_DIR_C)/arch/$(HOST_ARCH)
BUILD_DIR_STRING_C := $(BUILD_DIR_C)/string
BUILD_DIR_STDLIB_C := $(BUILD_DIR_C)/stdlib
BUILD_DIR_STDIO_C := $(BUILD_DIR_C)/stdio

CC := $(HOST_TARGET)-gcc
CXX := $(HOST_TARGET)-g++
AR := $(HOST_TARGET)-ar

C_STD := -std=c23
CXX_STD := -std=c++23
WARNINGS := -Wall -Wextra -Werror -pedantic
OPTIMIZING := -Og
DEBUGGING := -ggdb3
SANITIZING := -fsanitize=address -fsanitize=leak -fsanitize=undefined
OTHER := -ffreestanding

CFLAGS := $(C_STD) $(WARNINGS) $(OPTIMIZING) $(DEBUGGING) $(OTHER)
CXXFLAGS := $(CXX_STD)
LDFLAGS := -nostdlib -lgcc

include $(SRC_DIR)/kernel/Makefile
include $(SRC_DIR)/libc/Makefile

.PHONY: all init kernel libc run-elf run-iso burn-iso clean
all: init kernel libc
	cp $(SRC_DIR)/grub.cfg $(GRUB_DIR)/
	grub-mkrescue $(SYSROOT_DIR) -o $(OUTPUT_ISO)

init:
	@mkdir -p $(GRUB_DIR) $(LIB_DIR) $(INCLUDE_DIR)
	@mkdir -p $(BUILD_DIR_ARCH_K) $(BUILD_DIR_ARCH_C) $(BUILD_DIR_KERNEL_K)
	@mkdir -p $(BUILD_DIR_STDIO_C) $(BUILD_DIR_STDLIB_C) $(BUILD_DIR_STRING_C)

libc: kernel all_c

kernel: all_k

# grub-pc-bin is needed to load an ELF file
run-elf:
	$(QEMU) -display curses -kernel $(OUTPUT_ELF)

run-iso:
	$(QEMU) -display curses -cdrom $(OUTPUT_ISO)

# For safety, disk BURN_DISK must be explicitly defined via command line
burn-iso:
	dd if=$(OUTPUT_ISO) of=$(BURN_DISK) bs=1M status=progress

clean: init
	rm -rf $(BUILD_DIR)/*
	rm -rf $(INCLUDE_DIR)/*
	rm -rf $(BOOT_DIR)/*
