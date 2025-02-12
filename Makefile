SRC_DIR := StarDreamOS
BUILD_DIR := build
ISO_DIR := iso

OUTPUT_ELF = $(BUILD_DIR)/kernel.elf
OUTPUT_ISO = $(BUILD_DIR)/kernel.iso

WARNINGS := -Wall -Wextra
C_STD := -std=c17

# Add pattern rules to be more concise
.PHONY: all
.PHONY: run-elf
.PHONY: run-iso
.PHONY: clean

all:
	i686-elf-gcc $(C_STD) -ffreestanding -g -c $(SRC_DIR)/start.s -o $(BUILD_DIR)/start.o $(WARNINGS)
	i686-elf-gcc $(C_STD) -ffreestanding -g -c $(SRC_DIR)/kernel.c -o $(BUILD_DIR)/kernel.o $(WARNINGS)
	i686-elf-gcc -ffreestanding -nostdlib -g -T $(SRC_DIR)/linker.ld $(BUILD_DIR)/start.o $(BUILD_DIR)/kernel.o -o $(OUTPUT_ELF) -lgcc $(WARNINGS)

	cp $(BUILD_DIR)/kernel.elf $(ISO_DIR)/boot/kernel.elf
	grub-mkrescue $(ISO_DIR) -o $(OUTPUT_ISO)
	@grub-file --is-x86-multiboot $(OUTPUT_ELF) || echo "Warning: no valid multiboot-v1 header."

run-elf:
	qemu-system-i386 -display curses -kernel $(OUTPUT_ELF)

run-iso:
	qemu-system-i386 -display curses -cdrom $(OUTPUT_ISO)

clean:
	rm -rf $(BUILD_DIR)/*
