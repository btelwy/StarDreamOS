ARCHDIR = ./arch/$(HOST)

include $(ARCHDIR)/make.config

CFLAGS := $(CFLAGS) $(ARCH_CFLAGS) -D__is_libc
CXXFLAGS := $(CXXFLAGS) $(ARCH_CXXFLAGS) -D__is_libc
LIBK_CFLAGS := $(LIBK_CFLAGS) $(KERNEL_ARCH_CFLAGS) -D__is_libk
LIBK_CXXFLAGS := $(LIBK_CXXFLAGS) $(KERNEL_ARCH_CXXFLAGS) -D__is_libk

FREEOBJS=\
$(ARCH_FREEOBJS) \
./stdio/printf.o \
./stdio/putchar.o \
./stdio/puts.o \
./stdlib/abort.o \
./string/memcmp.o \
./string/memcpy.o \
./string/memmove.o \
./string/memset.o \
./string/strlen.o \

HOSTEDOBJS =\
$(ARCH_HOSTEDOBJS) \

OBJS =\
$(FREEOBJS) \
$(HOSTEDOBJS) \

LIBK_OBJS = $(FREEOBJS:.o=.libk.o)

#BINARIES=libc.a libk.a # Not ready for libc yet.
BINARIES = libk.a

.PHONY: all_c clean_c install_c install-headers_c install-libs_c
.EXTENSIONS: .o .libk.o .c .S

all_c: $(BINARIES)

libc.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

libk.a: $(LIBK_OBJS)
	$(AR) rcs $@ $(LIBK_OBJS)

.c.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CXXFLAGS)

.c.S:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CXXFLAGS)

.c.libk.o:
	$(CC) -MD -c $< -o $@ $(LIBK_CFLAGS) $(LIBK_CXXFLAGS)

.S.libk.o:
	$(CC) -MD -c $< -o $@ $(LIBK_CFLAGS) $(LIBK_CXXFLAGS)

clean_c:
	rm -f $(BINARIES) *.a
	rm -f $(OBJS) $(LIBK_OBJS) *.o */*.o */*/*.o
	rm -f $(OBJS:.o=.d) $(LIBK_OBJS:.o=.d) *.d */*.d */*/*.d

install_c: install-headers_c install-libs_c

install-headers_c:
	mkdir -p $(INCLUDEDIR)
	cp -R --preserve=timestamps ./include/* $(INCLUDEDIR)/

install-libs_c: $(BINARIES)
	mkdir -p $(LIBDIR)
	cp $(BINARIES) $(LIBDIR)/

-include $(OBJS:.o=.d)
-include $(LIBK_OBJS:.o=.d)
