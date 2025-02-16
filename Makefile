.PHONY: all clean init install-headers libc kernel make-iso run-elf run-iso

all: init install-headers libc kernel make-iso

OS := stardreamos
HOST_TARGET := i686-elf
HOST_ARCH := i386
QEMU := qemu-system-$(HOST_ARCH)

PROJECT_DIR := $(HOME)/projects/StarDreamOS

SRC_DIR := $(PROJECT_DIR)/StarDreamOS
BUILD_DIR := $(PROJECT_DIR)/build
SYSROOT_DIR := $(PROJECT_DIR)/sysroot

BUILD_DIR_K := $(BUILD_DIR)/kernel
BUILD_DIR_KERNEL_K := $(BUILD_DIR_K)/kernel
BUILD_DIR_ARCH_K := $(BUILD_DIR_K)/arch/$(HOST_ARCH)

BUILD_DIR_C := $(BUILD_DIR)/libc
BUILD_DIR_ARCH_C := $(BUILD_DIR_C)/arch/$(HOST_ARCH)
BUILD_DIR_STRING_C := $(BUILD_DIR_C)/string
BUILD_DIR_STDLIB_C := $(BUILD_DIR_C)/stdlib
BUILD_DIR_STDIO_C := $(BUILD_DIR_C)/stdio

# Architecture-independent files, i.e., /
PREFIX := $(SYSROOT_DIR)
# Architecture-dependent files, e.g., /i686-elf
EXEC_PREFIX := $(SYSROOT_DIR)/$(HOST_TARGET)

HOME_DIR := $(PREFIX)/home
ETC_DIR := $(PREFIX)/etc
TMP_DIR := $(PREFIX)/tmp
BOOT_DIR := $(PREFIX)/boot
GRUB_DIR := $(PREFIX)/boot/grub

BIN_DIR := $(PREFIX)/usr/bin
SBIN_DIR := $(PREFIX)/usr/sbin
INCLUDE_DIR := $(PREFIX)/usr/include
LIBEXEC_DIR := $(PREFIX)/usr/libexec
LIB_DIR := $(PREFIX)/usr/lib
GCC_DIR := $(LIB_DIR)/gcc/i686-elf/14.2.0/include

CC := $(HOST_TARGET)-gcc
CXX := $(HOST_TARGET)-g++

C_STD := -std=c23
CXX_STD := -std=c++23
WARNINGS := -Wall -Wextra -Werror -pedantic
OPTIMIZING := -Og
DEBUGGING := -ggdb
SANITIZING := -fsanitize=address -fsanitize=leak -fsanitize=undefined
DIRECTORIES := --sysroot=$(SYSROOT_DIR) -isystem $(INCLUDE_DIR) -L$(LIB_DIR) -B $(EXEC_PREFIX)/bin
OTHER := -ffreestanding

CFLAGS := $(C_STD) $(WARNINGS) $(OPTIMIZING) $(DEBUGGING) $(DIRECTORIES) $(OTHER)
CXXFLAGS := $(CXX_STD)
LDFLAGS := -nostdlib -lgcc

include $(SRC_DIR)/libc/Makefile
include $(SRC_DIR)/kernel/Makefile

init:
# Think about automating builds if not present
# These directories are only in sysroot's root
	@stat $(BIN_DIR) || echo "Error: sysroot/usr/bin must already contain binutils and gcc builds."
	@stat $(LIB_DIR) || echo "Error: sysroot/usr/lib must already contain gcc build."
	@stat $(EXEC_PREFIX) || echo "Error: sysroot/$$(EXEC_PREFIX) must already contain gcc build."
	@mkdir -p $(GRUB_DIR) $(TMP_DIR) $(ETC_DIR) $(HOME_DIR)

# These directories are in sysroot's /usr directory, then symlinked to its root
	@mkdir -p $(LIB_DIR) $(LIBEXEC_DIR) $(INCLUDE_DIR)
	@ln -sf $(LIB_DIR) $(SYSROOT_DIR)/
	@ln -sf $(LIBEXEC_DIR) $(SYSROOT_DIR)/
	@ln -sf $(INCLUDE_DIR) $(SYSROOT_DIR)/
	@ln -sf $(BIN_DIR) $(SYSROOT_DIR)/
	@ln -sf $(SBIN_DIR) $(SYSROOT_DIR)/

# Build directory sub-directories
	@mkdir -p $(BUILD_DIR_ARCH_K) $(BUILD_DIR_ARCH_C) $(BUILD_DIR_KERNEL_K)
	@mkdir -p $(BUILD_DIR_STDIO_C) $(BUILD_DIR_STDLIB_C) $(BUILD_DIR_STRING_C)

install-headers: install-headers-k install-headers-c

libc: all-c install-libs-c

kernel: all-k install-kernel-k

make-iso:
	cp $(SRC_DIR)/grub.cfg $(GRUB_DIR)/
	@grub-mkrescue $(SYSROOT_DIR) -o $(BUILD_DIR)/$(OS).iso

# grub-pc-bin is needed to load an ELF file
run-elf:
	$(QEMU) -display curses -kernel $(BUILD_DIR)/$(OS).elf

run-iso:
	$(QEMU) -display curses -cdrom $(BUILD_DIR)/$(OS).iso

clean:
	@rm -rf $(BUILD_DIR)/*
	@rm -rf $(INCLUDE_DIR)/*
	@rm -rf $(BOOT_DIR)/*
	@rm -rf $(LIB_DIR)/*.a
