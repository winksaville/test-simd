# Makefile for test-simd
# Parameters:
#   DBG=0 or 1 (default = 0)

# _DBG will be 0 if DBG isn't defined on the command line
_DBG = +$(DBG)
ifeq ($(_DBG), +)
  _DBG = 0
endif

CC=clang
CFLAGS=-Os -g -Wall -std=c11 -mavx2 -DDBG=$(_DBG)
OD=objdump
ODFLAGS=-S -M  x86_64,intel

LNK=$(CC)
LNKFLAGS=-lm

OUTDIR=out
SRCDIR=src

test-simd-obj-deps=$(OUTDIR)/test-simd.o $(OUTDIR)/rand0_1.o
test-simd-hdr-deps=$(SRCDIR)/rand0_1.h Makefile

all: $(OUTDIR) $(OUTDIR)/test-simd

$(OUTDIR)/rand0_1.o : $(SRCDIR)/rand0_1.c $(test-simd-hdr-deps)
	$(CC) $(CFLAGS) -c $< -o $@
	$(OD) $(ODFLAGS) $@ > $@.asm

$(OUTDIR)/test-simd.o : $(SRCDIR)/test-simd.c $(test-simd-hdr-deps)
	$(CC) $(CFLAGS) -c $< -o $@
	$(OD) $(ODFLAGS) $@ > $@.asm

$(OUTDIR)/test-simd : $(test-simd-obj-deps)
	$(LNK) $(LNKFLAGS) $(test-simd-obj-deps)  -o $@

$(OUTDIR):
	mkdir -p $(OUTDIR)

test: $(OUTDIR)/test-simd
	./test-simd $(MAKECMDGOALS)

clean :
	@rm -rf $(OUTDIR)
