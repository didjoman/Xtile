# Options de compilation : 
CC = gcc 
COPT = 
CFLAGS = $(COPT) -Wall -Wextra -Werror -g -std=c99

# Dossiers
SHELLSOURCEDIR = src/shell
CSOURCEDIR = src/c
BUILDDIR = bin

# Fichiers sources et destinations
SRCS = $(wildcard src/c/*.c)
OBJS = $(wildcard bin/*) #$(CSRC:.c=.o)
XTILE_C_LIB = xtile_c_lib
XTILE_EVENTS = xtile_events

# Bibliothèques et includes : 
INCLUDES = 
LFLAGS = 
LIBS = -lX11   


.PHONY: depend clean cpSh createShorctut

default: all
all:    $(BUILDDIR)/$(XTILE_C_LIB).o  $(BUILDDIR)/$(XTILE_EVENTS).o cpSh createShorctut

$(BUILDDIR)/$(XTILE_EVENTS).o : $(CSOURCEDIR)/$(XTILE_EVENTS).c
	$(CC) $(CFLAGS) $(INCLUDES)  $(CSOURCEDIR)/$(XTILE_EVENTS).c -o $(BUILDDIR)/$(XTILE_EVENTS).o $(LFLAGS) $(LIBS)

$(BUILDDIR)/$(XTILE_C_LIB).o : $(CSOURCEDIR)/$(XTILE_C_LIB).c
	$(CC) $(CFLAGS) $(INCLUDES)  $(CSOURCEDIR)/$(XTILE_C_LIB).c -o $(BUILDDIR)/$(XTILE_C_LIB).o $(LFLAGS) $(LIBS)

cpSh:
	cp $(SHELLSOURCEDIR)/* $(BUILDDIR)

createShorctut:
	echo '#!/bin/sh\n\nWAY=$$(cd $$(dirname $$0); pwd)\ncd $$WAY/bin\n./xtile_events.o;' > xtile && chmod u+x xtile

clean:
	$(RM) $(OBJS) xtile
