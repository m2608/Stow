# Собирает и устанавливает `make` с поддержкой `guile`.

PREFIX   := $(HOME)/.local
MAKEFILE := $(lastword $(MAKEFILE_LIST))
BASE     := "https://ftp.gnu.org/gnu/make/"
TARBALL  := $(shell curl -sL "$(BASE)" | xmllint --html --xpath '//tr[td[2][a]]/td[2]/a/@href' - | grep -E '"make-[0-9.]+[.]tar[.]gz"' | sed -r 's/^[ ]*href="//' | sed -r 's/"$$//' | sort -V | tail -n 1)
SRC_DIR  := $(shell basename "$(TARBALL)" ".tar.gz")

all: install

download:
	curl -O "$(BASE)$(TARBALL)"

extract: download
	tar -xf "$(TARBALL)"

configure: extract
	cd "$(SRC_DIR)" && ./configure --with-guile --prefix="$(PREFIX)"

build: configure
	$(MAKE) -C "$(SRC_DIR)"

distclean:
	rm -rf "$(SRC_DIR)" "$(TARBALL)"

install: build
	$(MAKE) -C "$(SRC_DIR)" install
	$(MAKE) -f "$(MAKEFILE)" distclean
