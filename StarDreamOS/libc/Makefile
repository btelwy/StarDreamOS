.PHONY: all-c install-all-c install-headers-c install-libs-c

LIBC_DIR := $(SRC_DIR)/libc
LIBC_INCLUDE_DIR := $(LIBC_DIR)/include
ARCH_DIR_C := $(LIBC_DIR)/arch/$(HOST_ARCH)

include $(ARCH_DIR_C)/make.config

CFLAGS_C := $(CFLAGS) $(ARCH_CFLAGS_C) -D__is_libk
CXXFLAGS_C := $(CXXFLAGS) $(ARCH_CXXFLAGS_C)
LIBK_CFLAGS_C := $(CFLAGS_C) $(KERNEL_ARCH_CFLAGS_C)
LIBK_CXXFLAGS_C := $(CXXFLAGS_C) $(KERNEL_ARCH_CXXFLAGS_C)

FREE_OBJS_C=\
$(ARCH_FREE_OBJS_C) \
$(BUILD_DIR_STDIO_C)/printf.o \
$(BUILD_DIR_STDIO_C)/putchar.o \
$(BUILD_DIR_STDIO_C)/puts.o \
$(BUILD_DIR_STDLIB_C)/abort.o \
$(BUILD_DIR_STRING_C)/memcmp.o \
$(BUILD_DIR_STRING_C)/memcpy.o \
$(BUILD_DIR_STRING_C)/memmove.o \
$(BUILD_DIR_STRING_C)/memset.o \
$(BUILD_DIR_STRING_C)/strlen.o

HOSTED_OBJS_C =\
$(ARCH_HOSTED_OBJS_C)

OBJS_C =\
$(FREE_OBJS_C) \
$(HOSTED_OBJS_C)

LIBK_OBJS_C = $(FREE_OBJS_C:.o=.libk.o)

#BINARIES=libc.a libk.a # libc not ready yet
BINARIES_C = $(BUILD_DIR_C)/libk.a

all-c: $(BINARIES_C)

$(BUILD_DIR_C)/libk.a: $(LIBK_OBJS_C)
	$(AR) rcs $@ $^

#$(BUILD_DIR_C)/libc.a: $(OBJS_C)
#	$(AR) rcs $@ $^

$(BUILD_DIR_C)/%.o: $(LIBC_DIR)/%.c
	$(CC) -c $< -o $@ $(CFLAGS_C)

$(BUILD_DIR_C)/%.o: $(LIBC_DIR)/%.S
	$(CC) -c $< -o $@ $(CFLAGS_C)

$(BUILD_DIR_C)/%.libk.o: $(LIBC_DIR)/%.c
	$(CC) -c $< -o $@ $(LIBK_CFLAGS_C)

$(BUILD_DIR_C)/%.libk.o: $(LIBC_DIR)/%.S
	$(CC) -c $< -o $@ $(LIBK_CFLAGS_C)

install-all-c: install-headers-c install-libs-c

install-headers-c:
	cp -R --preserve=timestamps $(LIBC_INCLUDE_DIR)/* $(INCLUDE_DIR)/

install-libs-c: $(BINARIES_C)
	cp $^ $(LIB_DIR)/
