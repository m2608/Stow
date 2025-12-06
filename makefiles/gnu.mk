# Build and install one of gnu tools.

# User must define a tool name.
ifndef NAME
    $(error NAME is not defined)
endif

# User may define configure params for a tool.
CONFIGURE_PARAMS ?= ""

PREFIX   := $(HOME)/.local
MAKEFILE := $(lastword $(MAKEFILE_LIST))
BASE     := "https://ftp.gnu.org/gnu/$(NAME)/"
TARBALL  := $(shell curl -sL "$(BASE)" | xmllint --html --xpath '//tr[td[2][a]]/td[2]/a/@href' - | grep -E '"$(NAME)-[0-9.]+[.]tar[.]gz"' | sed -r 's/^[ ]*href="//' | sed -r 's/"$$//' | sort -V | tail -n 1)
SRC_DIR  := $(shell basename "$(TARBALL)" ".tar.gz")

all: install

download:
	curl -O "$(BASE)$(TARBALL)"

extract: download
	tar -xf "$(TARBALL)"

configure: extract
	cd "$(SRC_DIR)" && ./configure $(CONFIGURE_PARAMS) --prefix="$(PREFIX)"

build: configure
	$(MAKE) -C "$(SRC_DIR)"

distclean:
	rm -rf "$(SRC_DIR)" "$(TARBALL)"

install: build
	$(MAKE) -C "$(SRC_DIR)" install
	$(MAKE) -f "$(MAKEFILE)" distclean
