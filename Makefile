MAJOR=1
MINOR=0
FIX=0
COMMIT=$(shell git log -1 --format="%h")
CFLAGS=
TARGETS=fromnsk tonsk
OBJECTS=version.o

all: $(TARGETS)

fromnsk: fromnsk.cpp $(OBJECTS)
	c99 $(CFLAGS) $(OBJECTS) $< -o $@

tonsk: tonsk.cpp $(OBJECTS)
	c99 $(CFLAGS) $(OBJECTS) $< -o $@

version.o: version.cpp
	c99 $(CFLAGS) -c $< -o $@
version.cpp: Makefile
	echo $(COMMIT) | \
	sed '1,$$s/.*/$(MAJOR).$(MINOR).$(FIX).&/' | \
	sed '1,$$s/.*/#include "version.h"\nchar *getVersion() {\nreturn "&";\n}\n/' \
	> version.cpp

clean:
	rm -f $(TARGETS) $(OBJECTS) version.cpp
