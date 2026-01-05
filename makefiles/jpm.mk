MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

PREFIX       ?= $(HOME)/.local
TEMP_FOLDER  := .build
CLONE_FOLDER := $(TEMP_FOLDER)/jpm
REPOSITORY   := "https://github.com/janet-lang/jpm"
LATEST_TAG   := $(shell git ls-remote --tags https://github.com/janet-lang/jpm \
	| sed -r -n 's/^.*\/(v[0-9]+[.][0-9]+[.][0-9]+)$$/\1/p' \
	| sort -V \
	| tail -n 1)

all: install clean

clone:
	mkdir -p "$(TEMP_FOLDER)"
	git clone -b $(LATEST_TAG) --single-branch $(REPOSITORY) $(CLONE_FOLDER)

clean:
	test -d "$(CLONE_FOLDER)" && rm -rf "$(CLONE_FOLDER)"

install: clone
	cd "$(CLONE_FOLDER)" && PREFIX="$(PREFIX)" janet bootstrap.janet
