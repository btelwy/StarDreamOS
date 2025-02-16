.PHONY: all-k install-all-k install-headers-k install-kernel-k

KERNEL_DIR := $(SRC_DIR)/kernel
KERNEL_INCLUDE_DIR := $(KERNEL_DIR)/include
ARCH_DIR_K := $(KERNEL_DIR)/arch/$(HOST_ARCH)

include $(ARCH_DIR_K)/make.config

CFLAGS_K := $(CFLAGS) $(KERNEL_ARCH_CFLAGS_K) -D__is_kernel
CXXFLAGS_K := $(CXXFLAGS) $(KERNEL_ARCH_CXXFLAGS_K)
LDFLAGS_K := $(LDFLAGS) $(KERNEL_ARCH_LDFLAGS_K) -lk
LIBS_K := $(LIB_DIR)/*.a $(KERNEL_ARCH_LIBS_K)

# KERNEL_ARCH_OBJS_K: currently boot.o, tty.o
KERNEL_OBJS_K =\
$(KERNEL_ARCH_OBJS_K) \
$(BUILD_DIR_KERNEL_K)/kernel.o

OBJS_K =\
$(BUILD_DIR_ARCH_K)/crti.o \
$(BUILD_DIR_ARCH_K)/crtbegin.o \
$(KERNEL_OBJS_K) \
$(BUILD_DIR_ARCH_K)/crtend.o \
$(BUILD_DIR_ARCH_K)/crtn.o

all-k: $(BUILD_DIR)/$(OS).elf

$(BUILD_DIR)/$(OS).elf: $(OBJS_K)
	$(CC) -T $(ARCH_DIR_K)/linker.ld -o $@ \
		$(CFLAGS_K) \
		$(LDFLAGS_K) \
		$(BUILD_DIR_ARCH_K)/crti.o \
		$(BUILD_DIR_ARCH_K)/crtbegin.o \
		$(KERNEL_OBJS_K) \
		$(LIBS_K) \
		$(BUILD_DIR_ARCH_K)/crtend.o \
		$(BUILD_DIR_ARCH_K)/crtn.o
	@grub-file --is-x86-multiboot $@ || echo "Error: no Multiboot header detected."

$(BUILD_DIR_ARCH_K)/crtbegin.o $(BUILD_DIR_ARCH_K)/crtend.o:
	cp $$($(CC) -print-file-name=$(@F)) $(BUILD_DIR_ARCH_K)/

$(BUILD_DIR_K)/%.o: $(KERNEL_DIR)/%.c
	$(CC) -c $< -o $@ $(CFLAGS_K)

$(BUILD_DIR_K)/%.o: $(KERNEL_DIR)/%.S
	$(CC) -c $< -o $@ $(CFLAGS_K)

install-all-k: install-headers-k install-kernel-k

install-headers-k:
	cp -R --preserve=timestamps $(KERNEL_INCLUDE_DIR)/* $(INCLUDE_DIR)/

install-kernel-k: $(BUILD_DIR)/$(OS).elf
	@cp $< $(BOOT_DIR)/
