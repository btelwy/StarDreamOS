OS := stardreamos
HOST_TARGET := i686-elf
HOST_ARCH := i386
QEMU := qemu-system-i386

SRC_DIR := ./StarDreamOS
BUILD_DIR := ./build

BUILD_DIR_K = $(BUILD_DIR)/kernel
BUILD_DIR_ARCH_K = $(BUILD_DIR_K)/arch/$(HOST_ARCH)
BUILD_DIR_C = $(BUILD_DIR)/libc
BUILD_DIR_ARCH_C = $(BUILD_DIR_C)/arch/$(HOST_ARCH)

SYSROOT_DIR := ./sysroot
PREFIX := $(SYSROOT_DIR)/usr
INCLUDE_DIR := $(PREFIX)/include
LIB_DIR := $(PREFIX)/lib
BOOT_DIR := $(SYROOT_DIR)/boot

OUTPUT_ELF = $(BOOT_DIR)/$(OS).elf
OUTPUT_ISO = $(BOOT_DIR)/$(OS).iso

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
	grub-mkrescue $(SYSROOT_DIR) -o $(OUTPUT_ISO)

init:
	mkdir -p $(BUILD_DIR_ARCH_K) $(BUILD_DIR_ARCH_C)
	mkdir -p $(BUILD_DIR_C)/stdio $(BUILD_DIR_C)/stdlib $(BUILD_DIR_C)/string
	mkdir -p $(BOOT_DIR) $(LIB_DIR) $(INCLUDE_DIR)

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

clean:
	rm -r $(BUILD_DIR)/*
	rm -r $(INCLUDE_DIR)/*
	rm -r $(BOOT_DIR)/*
