BOOTDIR ?= $(PREFIX)/boot
INCLUDEDIR ?= $(PREFIX)/usr/include

ARCHDIR = ./arch/$(HOST)

include $(ARCHDIR)/make.config

CFLAGS := $(CFLAGS) $(KERNEL_ARCH_CFLAGS)
CXXFLAGS := $(CXXFLAGS) $(KERNEL_ARCH_CXXFLAGS)
LDFLAGS := $(LDFLAGS) $(KERNEL_ARCH_LDFLAGS)
LIBS := $(LIBS) $(KERNEL_ARCH_LIBS) -D__is_kernel

KERNEL_OBJS =\
$(KERNEL_ARCH_OBJS) \
./kernel/kernel.o \

OBJS =\
$(ARCHDIR)/crti.o \
$(ARCHDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(ARCHDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

LINK_LIST =\
$(LDFLAGS) \
$(ARCHDIR)/crti.o \
$(ARCHDIR)/crtbegin.o \
$(KERNEL_OBJS) \
$(LIBS) \
$(ARCHDIR)/crtend.o \
$(ARCHDIR)/crtn.o \

.PHONY: all clean install install-headers install-kernel
.EXTENSIONS: .o .c .S

all: $(OS).kernel

$(OS).kernel: $(OBJS) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(LINK_LIST)
	grub-file --is-x86-multiboot $(OS).kernel || echo "Error: no Multiboot header detected."

$(ARCHDIR)/crtbegin.o $(ARCHDIR)/crtend.o:
	OBJ = $($(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=$(@F)) && cp "$$OBJ" $@

.c.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CXXFLAGS)

.S.o:
	$(CC) -MD -c $< -o $@ $(CFLAGS) $(CXXFLAGS)

clean:
	rm -f $(OS).kernel
	rm -f $(OBJS) *.o */*.o */*/*.o
	rm -f $(OBJS:.o=.d) *.d */*.d */*/*.d

install: install-headers install-kernel

install-headers:
	mkdir -p $(INCLUDEDIR)
	cp -R --preserve=timestamps ./include/* $(INCLUDEDIR)/

install-kernel: $(OS).kernel
	mkdir -p $(BOOTDIR)
	cp $(OS).kernel $(BOOTDIR)

-include $(OBJS:.o=.d)
