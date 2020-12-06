#!/usr/bin/make -f
# Copyright (C) 2020 Antti Helminen
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License

################################
# System configuration
################################
SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .cpp .o .h .dep

CXX 			:= g++
LD				:= ld
INSTALL			:= install
INSTALLDATA		:= install -m 644
OS				:= linux

CFLAGS	 		= -g -Wall $(DEFS) $(INC)
DEFS			= -std=c++17 -march=x86-64 -fPIC
INC				= -iquote $(incdir)
LDFLAGS			= -shared -Wl,-soname,$(SONAME)

prefix 			= /usr/local/
bindir 			= $(prefix)bin/
libdir			= $(prefix)lib/
includedir		= $(prefix)include/

################################
# Project files
################################
PROG_NAME 		= libbrb2.so
VERSION			= $(lastword 0 $(shell grep "\#define BRB2_MAJOR_VERSION" $(incdir)brb2.h))
MINOR			= $(lastword 0 $(shell grep "\#define BRB2_MINOR_VERSION" $(incdir)brb2.h))
PATCH			= $(lastword 0 $(shell grep "\#define BRB2_PATCH_VERSION" $(incdir)brb2.h))
SONAME			= $(PROG_NAME).$(VERSION)
REALNAME		= $(SONAME).$(MINOR).$(PATCH)

builddir 		= ./bin/$(OS)/
incdir			= ./inc/
src_basedir		= ./src/
srcdirs			= $(addsuffix /,$(shell find $(patsubst %/,%,$(src_basedir)) -type d))
resdir			= ./res/
3libdir			= ./lib/$(OS)/
depdir			= ./dep/$(OS)/
objdir			= ./obj/$(OS)/

dirs			= $(builddir) $(incdir) $(src_basedir) $(resdir) \
				$(3libdir) $(depdir) $(objdir)

SRCS	:= $(patsubst ./%,%,$(foreach dir, $(srcdirs),$(wildcard $(dir)*.cpp)))

RESS	:= \

LIBS	:= \

PCH		:= $(incdir)pch.h

################################
# Targets
################################

OBJS 			:= $(addprefix $(objdir),$(SRCS:.cpp=.o))
DEPENDENCY 		:= $(addprefix $(depdir),$(SRCS:.cpp=.dep))
GCH				:= $(PCH).gch
BUILD			:= $(objdir).lastbuild

vpath %.h		$(incdir)
vpath %.cpp		$(srcdirs)
vpath %.dep		$(depdir)
vpath %.o 		$(objdir)

.PHONY: all build install clean realclean rebuild installdirs

################################
# Make
################################

all: $(GCH) build

# GNU specific precompiled header: 
$(GCH): $(PCH)
	@echo [PRECOMPILED HEADER]
	$(CXX) -c $(CFLAGS) $<
	@echo

build: $(BUILD)
	@echo [PROJECT UP-TO-DATE]
	@echo

$(BUILD): $(OBJS)
	@echo [LINK]
	$(CXX) $(LDFLAGS) $^ -o $(builddir)$(REALNAME)
	@touch $@
	@echo

$(objdir)%.o : %.cpp %.dep
	@echo [COMPILE]
	$(CXX) -c $(CFLAGS) \
	-o $@ $<
	@echo

# Dependency generation:
# dep/main.dep: src/main.cpp inc/header.h
$(depdir)%.dep : %.cpp | $(dirs)
	@echo [DEPENDENCY]
	$(CXX) -c $(CFLAGS) \
	-MM -MP -MT $@ $< \
	> $@
	@echo

-include $(DEPENDENCY)

install: all
	@echo [INSTALL]
	$(INSTALLDATA) $(builddir)$(REALNAME) $(libdir)$(REALNAME)
	mkdir -p $(includedir)brb2
	$(INSTALLDATA) $(incdir)brb2.h $(includedir)brb2
	rm -f $(libdir)$(PROG_NAME)
	ln -s $(REALNAME) $(libdir)$(PROG_NAME)
	ldconfig
	@echo

clean:
	@echo [CLEAN]
ifdef builddir
	rm -f $(builddir)*
endif
	rm -f $(OBJS) $(DEPENDENCY) $(GCH) $(BUILD)
	@echo

realclean: clean
	rm -f $(libdir)$(REALNAME)
	rm -f $(libdir)$(SONAME)
	rm -f $(libdir)$(PROG_NAME)
	ldconfig
	@echo

rebuild: clean
	@echo [REBUILD]
	$(MAKE)
	@echo

# Directory structure
$(dirs):
	@echo [MKDIR dirs]
	mkdir -p $(dirs)
	mkdir -p $(foreach dir,$(patsubst ./%,%,$(srcdirs)),$(objdir)$(dir))
	mkdir -p $(foreach dir,$(patsubst ./%,%,$(srcdirs)),$(depdir)$(dir))
	@echo

installdirs:
	@echo [INSTALLDIRS]
	mkdir -p $(dirs)
	mkdir -p $(foreach dir,$(patsubst ./%,%,$(srcdirs)),$(objdir)$(dir))
	mkdir -p $(foreach dir,$(patsubst ./%,%,$(srcdirs)),$(depdir)$(dir))
	@echo
