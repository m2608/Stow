# Buld and install xxd from vim sources.

URL_MAKEFILE := https://github.com/vim/vim/raw/refs/heads/master/src/xxd/Makefile
URL_SOURCE   := https://github.com/vim/vim/raw/refs/heads/master/src/xxd/xxd.c
WORKPATH     := .build/xxd
BINARY       := xxd

all: install

fetch:
	curl --location --create-dirs --output-dir "$(WORKPATH)" --remote-name "$(URL_MAKEFILE)" && \
	curl --location --create-dirs --output-dir "$(WORKPATH)" --remote-name "$(URL_SOURCE)"

clean:
	rm -rf "$(WORKPATH)"

build: fetch
	$(MAKE) -C "$(WORKPATH)" -f Makefile

install: build
	cp "$(WORKPATH)/$(BINARY)" "$(HOME)/.local/bin/"
