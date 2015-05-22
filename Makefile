# This software code is owned and operated by Nexbridge Inc. and has been
# contributed to ITUGLIB. You are free to modify it, providing that you
# communicate the changes back to Nexbridge Inc. for inclusion into the
# main code branch. This code is subject to the ECLIPSE Public License
# and all the rights and obligations contained therein. You must
# preserve this license file and copyright statements in all copyright
# notices in source files.
#
# This software is provided without waranty or fitness of any kind. You
# are entirely responsible for any problems that might occur resulting
# from its use.
#
# Copyright (c) 2015 Nexbridge Inc.

MAJOR=1
MINOR=0
FIX=0
COMMIT=$(shell git log -1 --format="%h")
CFLAGS=-Wextensions
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
