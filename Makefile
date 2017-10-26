
CXX ?= g++
CXXFLAGS := -DZNEDI3_X86 -I./znedi3 -I./vsxx $(CPPFLAGS) -fPIC -Wall -O3 $(CXXFLAGS)
LDFLAGS := $(LDFLAGS)
LIBEXT ?= so

FILES_O := vsxx/vsxx_pluginmain.o vsznedi3/vsznedi3.o \
znedi3/znedi3_impl.o znedi3/weights.o znedi3/cpuinfo.o znedi3/kernel.o znedi3/znedi3.o \
znedi3/x86/cpuinfo_x86.o znedi3/x86/kernel_x86.o \
znedi3/x86/kernel_avx.o znedi3/x86/kernel_avx2.o znedi3/x86/kernel_avx512.o \
znedi3/x86/kernel_sse2.o znedi3/x86/kernel_sse.o znedi3/x86/kernel_f16c.o

all: libznedi3.$(LIBEXT)

clean:
	rm -f $(FILES_O) libznedi3.$(LIBEXT)

libznedi3.$(LIBEXT): $(FILES_O)
	$(CXX) -shared -s -o libznedi3.$(LIBEXT) $(FILES_O) $(LDFLAGS)

.cpp.o:
	$(CXX) -c $(CXXFLAGS) -o $*.o $*.cpp

install: libznedi3.$(LIBEXT) nnedi3_weights.bin
	install -c -d /usr/lib/vapoursynth
	install -c -m 755 libznedi3.$(LIBEXT) /usr/lib/vapoursynth/
	install -c -m 644 nnedi3_weights.bin /usr/lib/vapoursynth/
