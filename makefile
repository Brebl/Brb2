#!/usr/bin/make -f
# Copyright (C) 2020 Antti Helminen
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License

####################
# System configuration
####################
SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .cpp .o

CXX 			:= g++
LD				:= ld
PROG_NAME 		:= program
OS				:= linux
ARCH			:= x86
DEBUGFLAGS 		= -g $(DEFS) $(INC)
RELEASEFLAGS 	= -O $(DEFS) $(INC)
DEFS			= -std=c++17 -D BRB2_EXPORTS
INC				= -iquote $(incdir)

prefix 			= /usr/local/
bindir 			= $(prefix)bin/
infodir 		= $(prefix)info/

##########################
# Project files
###########################
debugdir 		= ./bin/$(OS)/$(ARCH)/
incdir			= ./inc/
src_basedir		= ./src
srcdirs			= $(addsuffix /,$(shell find $(src_basedir) -type d))
resdir			= ./res/
libdir			= ./lib/$(OS)/$(ARCH)/
depdir			= ./dep/$(OS)/$(ARCH)/
d_objdir		= ./obj/$(OS)/$(ARCH)/debug/
r_objdir		= ./obj/$(OS)/$(ARCH)/release/

mkdirs			:= $(debugdir) $(d_objdir) $(depdir)

vpath %.h		$(incdir)
vpath %.cpp		$(srcdirs)
vpath %.dep		$(depdir)
vpath %.o 		$(objdir)

SRCS := $(notdir $(foreach dir, $(srcdirs),$(wildcard $(dir)*.cpp)))

RESS := \

LIBS := \

###########################
# make
###########################

DEBUG_OBJS 		:= $(addprefix $(d_objdir),$(SRCS:.cpp=.o))
RELEASE_OBJS	:= $(addprefix $(r_objdir),$(SRCS:.cpp=.o))
DEPENDENCY 		:= $(addprefix $(depdir),$(SRCS:.cpp=.dep))


####################

.PHONY: all debug release clean

all: debug

debug: $(DEBUG_OBJS)
	@echo [LINK] 
	$(CXX) $(DEBUGFLAGS) $^ -o $(debugdir)$(PROG_NAME)

$(d_objdir)%.o : %.cpp %.dep
	@echo [COMPILE]
	$(CXX) -c $(DEBUGFLAGS) \
	-o $@ $<

release: $(RELEASE_OBJS)
	@echo [LINK] 
	$(CXX) $(RELEASEFLAGS) $^ -o $(bindir)$(PROG_NAME)

$(r_objdir)%.o : %.cpp %.dep
	@echo [COMPILE]
	$(CXX) -c $(RELEASEFLAGS) \
	-o $@ $<

# Dependency generation.
$(depdir)%.dep : %.cpp | $(mkdirs)
	@echo [DEPENDENCY]
	$(CXX) -c $(DEBUGFLAGS) \
	-MM -MP -MT $@ $< \
	> $@

-include $(DEPENDENCY) 
#dep/main.dep: src/main.cpp inc/header.h

$(mkdirs):
	@echo [MKDIRS]
	mkdir -p $(mkdirs)

installdirs: 
	$(srcdirs) \
	$(bindir) $(datadir) \
	$(libdir) $(infodir) \
	$(mandir)

clean:
	rm -r bin obj dep