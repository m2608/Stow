MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

PREFIX       ?= $(HOME)/.local
TEMP_FOLDER  := .build
CLONE_FOLDER := $(TEMP_FOLDER)/tmux
REPOSITORY   := "https://github.com/tmux/tmux"
LATEST_TAG   := $(shell git ls-remote --tags https://github.com/tmux/tmux \
	| sed -r -n 's/^.*\/([0-9]+[.][0-9]+[a-z]?)$$/\1/p' \
	| sort -V \
	| tail -n 1)

all: install clean

clone:
	mkdir -p "$(TEMP_FOLDER)"
	git clone -b $(LATEST_TAG) --single-branch $(REPOSITORY) $(CLONE_FOLDER)

build: clone
	cd $(CLONE_FOLDER) && sh autogen.sh && ./configure --prefix=$(PREFIX)
	$(MAKE) -C "$(CLONE_FOLDER)"

clean:
	test -d "$(CLONE_FOLDER)" && rm -rf "$(CLONE_FOLDER)"

install: build
	$(MAKE) -C "$(CLONE_FOLDER)" PREFIX=$(PREFIX) install
