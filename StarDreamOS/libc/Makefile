LIBC_DIR := $(SRC_DIR)/libc
LIBC_INCLUDE_DIR := $(LIBC_DIR)/include
ARCH_DIR_C := $(LIBC_DIR)/arch/$(HOST_ARCH)

include $(ARCH_DIR_C)/make.config

CFLAGS_C := $(CFLAGS) $(ARCH_CFLAGS_C) -D__is_libc
CXXFLAGS_C := $(CXXFLAGS) $(ARCH_CXXFLAGS_C) -D__is_libc
LIBK_CFLAGS_C := $(LIBK_CFLAGS_C) $(KERNEL_ARCH_CFLAGS_C) -D__is_libk
LIBK_CXXFLAGS_C := $(LIBK_CXXFLAGS_C) $(KERNEL_ARCH_CXXFLAGS_C) -D__is_libk

FREE_OBJS_C=\
$(ARCH_FREE_OBJS_C) \
$(BUILD_DIR_C)/stdio/printf.o \
$(BUILD_DIR_C)/stdio/putchar.o \
$(BUILD_DIR_C)/string/puts.o \
$(BUILD_DIR_C)/stdlib/abort.o \
$(BUILD_DIR_C)/string/memcmp.o \
$(BUILD_DIR_C)/string/memcpy.o \
$(BUILD_DIR_C)/string/memmove.o \
$(BUILD_DIR_C)/string/memset.o \
$(BUILD_DIR_C)/string/strlen.o \

HOSTED_OBJS_C =\
$(ARCH_HOSTED_OBJS_C) \

OBJS_C =\
$(FREE_OBJS_C) \
$(HOSTED_OBJS_C) \

LIBK_OBJS_C = $(FREE_OBJS_C:.o=.libk.o)

#BINARIES=libc.a libk.a # libc not ready yet
BINARIES_C = $(BUILD_DIR_C)/libk.a

.PHONY: all_c install_c install_headers_c install_libs_c

all_c: $(BINARIES_C)

$(BUILD_DIR_C)/libc.a: $(OBJS_C)
	$(AR) rcs $@ $(OBJS_C)

$(BUILD_DIR_C)/libk.a: $(LIBK_OBJS_C)
	$(AR) rcs $@ $(LIBK_OBJS_C)

$(BUILD_DIR_C)/%.o: $(LIBC_DIR)/%.c
	$(CC) -c $< -o $@ $(CFLAGS_C) $(CXXFLAGS_C)

$(BUILD_DIR_C)/%.o: $(LIBC_DIR)/%.S
	$(CC) -c $< -o $@ $(CFLAGS_C) $(CXXFLAGS_C)

$(BUILD_DIR_C)/%.libk.o: $(LIBC_DIR)/%.c
	$(CC) -c $< -o $@ $(LIBK_CFLAGS_C) $(LIBK_CXXFLAGS_C)

$(BUILD_DIR_C)/%.libk.o: $(LIBC_DIR)/%.S
	$(CC) -c $< -o $@ $(LIBK_CFLAGS_C) $(LIBK_CXXFLAGS_C)

install_c: install_headers_c install_libs_c

install_headers_c:
	cp -R --preserve=timestamps $(LIBC_INCLUDE_DIR)/* $(INCLUDE_DIR)/

install_libs_c: $(BINARIES_C)
	cp $^ $(LIB_DIR)/
