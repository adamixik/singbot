GCC = g++
OUTFILE = "Bin/example_module.so"

COMPILE_FLAGS = -c -O2 -fno-strict-aliasing -w -DLINUX -I../squirrel/ -I.

all:
	$(GCC) $(COMPILE_FLAGS) ./*.cpp
	$(GCC) $(COMPILE_FLAGS) ../squirrel/*.cpp
	$(GCC) -O2 -shared -o $(OUTFILE) *.o
	-rm -f *~ *.o
