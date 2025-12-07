MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

REPOSITORY := "https://github.com/mawww/kakoune/"
LATEST_TAG := $(shell git ls-remote --tags $(REPOSITORY) | sed -r -n 's/^.*\/(v[0-9]{4}[.][0-9]{2}[.][0-9]{2})$$/\1/p' | sort | tail -n 1)
CLONE_FOLDER := "kakoune"

clone:
	git clone -b $(LATEST_TAG) --single-branch $(REPOSITORY) $(CLONE_FOLDER)

build: clone
	$(MAKE) -C "$(CLONE_FOLDER)"

clean:
	test -d "$(CLONE_FOLDER)" && rm -rf "$(CLONE_FOLDER)"

install-lsp:
	cargo install --locked --git https://github.com/kakoune-lsp/kakoune-lsp.git kak-lsp

install: build
	PREFIX=$(HOME)/.local $(MAKE) -C "$(CLONE_FOLDER)" -e install

all: install install-lsp clean
