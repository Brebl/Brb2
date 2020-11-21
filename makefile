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
OS				:= linux
ARCH			:= x86
PROG_NAME 		= brb2_$(ARCH).so
DEBUGFLAGS 		= -g -Wall -fpic $(DEFS) $(INC)
RELEASEFLAGS 	= -O -fpic $(DEFS) $(INC)
LDFLAGS			= -shared
DEFS			= -std=c++17 -D BRB2_EXPORTS
INC				= -iquote $(incdir)

prefix 			= /usr/local/
bindir 			= $(prefix)bin/
libdir			= $(prefix)lib/$(basename $(PROG_NAME))/
infodir 		= $(prefix)info/

##########################
# Project files
###########################
debugdir 		= ./bin/$(OS)/$(ARCH)/
incdir			= ./inc/
src_basedir		= ./src
srcdirs			= $(addsuffix /,$(shell find $(src_basedir) -type d))
resdir			= ./res/
3libdir			= ./lib/$(OS)/$(ARCH)/
depdir			= ./dep/$(OS)/$(ARCH)/
d_objdir		= ./obj/$(OS)/$(ARCH)/debug/
r_objdir		= ./obj/$(OS)/$(ARCH)/release/

d_dirs			:= $(debugdir) $(d_objdir)
r_dirs			:= $(r_objdir) $(libdir)
all_dirs		:= $(debugdir) $(incdir) $(src_basedir) $(resdir) \
					$(3libdir) $(depdir) $(d_objdir) $(r_objdir)

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

.PHONY: all debug release installdirs clean

all: debug

debug: $(DEBUG_OBJS)
	@echo [LINK] 
	$(CXX) $(LDFLAGS) $^ -o $(debugdir)$(PROG_NAME)

$(d_objdir)%.o : %.cpp %.dep | $(d_dirs)
	@echo [COMPILE]
	$(CXX) -c $(DEBUGFLAGS) \
	-o $@ $<

install: $(RELEASE_OBJS)
	@echo [LINK] 
	$(CXX) $(LDFLAGS) $^ -o $(libdir)$(PROG_NAME)

$(r_objdir)%.o : %.cpp %.dep | $(r_dirs)
	@echo [COMPILE]
	$(CXX) -c $(RELEASEFLAGS) \
	-o $@ $<

# Dependency generation.
$(depdir)%.dep : %.cpp | $(depdir)
	@echo [DEPENDENCY]
	$(CXX) -c $(DEBUGFLAGS) \
	-MM -MP -MT $@ $< \
	> $@

-include $(DEPENDENCY) 
#dep/main.dep: src/main.cpp inc/header.h

$(depdir):
	@echo [MKDIR depdir]
	mkdir -p $(depdir)

$(d_dirs):
	@echo [MKDIR d_dirs]
	mkdir -p $(d_dirs)

$(r_dirs):
	@echo [MKDIR r_dirs]
	mkdir -p $(r_dirs)

installdirs: 
	@echo [INSTALLDIRS]
	mkdir -p $(all_dirs)

clean:
	rm -f $(bindir)$(PROG_NAME)
	rm -f $(debugdir)* $(d_objdir)* $(r_objdir)* $(libdir)* $(depdir)*
