KERNEL_DIR := $(SRC_DIR)/kernel
ARCH_DIR_K := $(KERNEL_DIR)/arch/$(HOST_ARCH)
KERNEL_INCLUDE_DIR := $(KERNEL_DIR)/include

include $(ARCH_DIR_K)/make.config

CFLAGS_K := $(CFLAGS) $(KERNEL_ARCH_CFLAGS_K) -D__is_kernel
CXXFLAGS_K := $(CXXFLAGS) $(KERNEL_ARCH_CXXFLAGS_K) -D__is_kernel
LDFLAGS_K := $(LDFLAGS) $(KERNEL_ARCH_LDFLAGS_K) -D__is_kernel
LIBS_K := $(KERNEL_ARCH_LIBS_K) -D__is_kernel

KERNEL_OBJS_K =\
$(KERNEL_ARCH_OBJS_K) \ #BUILD_DIR_ARCH_K/boot.o, BUILD_DIR_ARCH_K/tty.o
$(BUILD_DIR_K)/kernel/kernel.o \

OBJS_K =\
$(BUILD_DIR_ARCH_K)/crti.o \
$(BUILD_DIR_ARCH_K)/crtbegin.o \
$(KERNEL_OBJS_K) \
$(BUILD_DIR_ARCH_K)/crtend.o \
$(BUILD_DIR_ARCH_K)/crtn.o \

LINK_LIST_K =\
$(LDFLAGS_K) \
$(BUILD_DIR_ARCH_K)/crti.o \
$(BUILD_DIR_ARCH_K)/crtbegin.o \
$(KERNEL_OBJS_K) \
$(LIBS_K) \
$(BUILD_DIR_ARCH_K)/crtend.o \
$(BUILD_DIR_ARCH_K)/crtn.o \

.PHONY: all_k install_k install_headers_k install_kernel_k

all_k: $(OS).kernel

$(BUILD_DIR_K)/$(OS).kernel: $(OBJS_K)
	$(CC) -T $(ARCH_DIR_K)/linker.ld -o $@ $(CFLAGS_K) $(LINK_LIST_K)
	@grub-file --is-x86-multiboot $(OS).kernel || echo "Error: no Multiboot header detected."

# usr/lib/gcc/i686-elf/14.2.0/
$(BUILD_DIR_ARCH_K)/crtbegin.o $(BUILD_DIR_ARCH_K)/crtend.o:
	cp $($(CC) -print-file-name=$(@F)) $@

$(BUILD_DIR_K)/%.o: $(KERNEL_DIR)/%.c
	$(CC) -c $< -o $@ $(CFLAGS_K) $(CXXFLAGS_K)

$(BUILD_DIR_K)/%.o: $(KERNEL_DIR)/%.S
	$(CC) -c $< -o $@ $(CFLAGS_K) $(CXXFLAGS_K)

install_k: install_headers_k install_kernel_k

install_headers_k:
	cp -R --preserve=timestamps $(KERNEL_INCLUDE_DIR)/* $(INCLUDE_DIR)/

install_kernel_k: $(BUILD_DIR_K)/$(OS).kernel
	cp $< $(BOOT_DIR)/
