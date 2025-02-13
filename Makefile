CC := i686-elf-gcc
QEMU := qemu-system-i386

SYSROOT_DIR := sysroot
SRC_DIR := kernel
BUILD_DIR := build

OUTPUT_ELF = $(BUILD_DIR)/kernel.elf
OUTPUT_ISO = $(SYSROOT_DIR)/boot/kernel.iso

WARNINGS := -Wall -Wextra -Werror -pedantic
C_STD := -std=c23
OPTIMIZING := -Og
DEBUGGING := -ggdb3
SANITIZING := -fsanitize=address -fsanitize=leak -fsanitize=undefined
OTHER := -ffreestanding
CFLAGS := $(C_STD) $(WARNINGS) $(OPTIMIZING) $(DEBUGGING) $(OTHER)

# Add pattern rules and real targets
.PHONY: all

.PHONY: run-elf
.PHONY: run-iso
.PHONY: burn-iso
.PHONY: clean

all:
	$(CC) $(CFLAGS) -c $(SRC_DIR)/start.s -o $(BUILD_DIR)/start.o
	$(CC) $(CFLAGS) -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o
	$(CC) $(CFLAGS) -nostdlib -T $(SRC_DIR)/linker.ld $(BUILD_DIR)/start.o $(BUILD_DIR)/kernel.o -o $(OUTPUT_ELF) -lgcc

	@cp $(OUTPUT_ELF) $(SYSROOT_DIR)/boot/kernel.elf
	@grub-mkrescue $(SYSROOT_DIR) -o $(OUTPUT_ISO)
	@grub-file --is-x86-multiboot $(OUTPUT_ELF) || echo "Warning: no valid multiboot-v1 header."

# grub-pc-bin is needed to load an ELF file
run-elf:
	$(QEMU) -display curses -kernel $(OUTPUT_ELF)

run-iso:
	$(QEMU) -display curses -cdrom $(OUTPUT_ISO)

# For safety, disk BURN_DISK must be explicitly defined via command line
burn-iso:
	dd if=$(OUTPUT_ISO) of=$(BURN_DISK) bs=1M status=progress

clean:
	rm -rf $(BUILD_DIR)/*
