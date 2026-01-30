MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/makefiles/functions.mk

ARCH := $(shell uname -m | tr A-Z a-z | sed 's/x86_64/amd64/')
OS   := $(shell uname -s | tr A-Z a-z)

all: symlinks

#
# GNU tools
#

install-make:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/gnu.mk NAME=make CONFIGURE_PARAMS="--with-guile"

install-stow:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/gnu.mk NAME=stow

install-libarchive:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/gnu.mk NAME=libarchive BASE="https://libarchive.org/downloads" XPATH="//a/@href"

#
# Stowed config files
#

symlinks:
	stow --target=$(HOME) --restow --no-folding stowed

delete:
	stow --target=$(HOME) --delete */

#
# Fonts
#

fetch-fonts:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/fonts.mk

#
# Clojure tools
#

clojure-tools:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/clojure-tools.mk

#
# Image Magick
#

magick: MAGICK := "$(HOME)/.local/bin/magick"
magick:
	curl -L "https://imagemagick.org/archive/binaries/magick" > $(MAGICK);
	chmod +x $(MAGICK)

#
# Editors
#

install-nvim: NVIM := "$(HOME)/.local/bin/nvim"
install-nvim:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,neovim/neovim-releases,"^nvim-linux-x86_64[.]appimage$$") > $(NVIM);
	chmod +x $(NVIM)
else
	@echo "Unsupported arch: $(ARCH)"
endif

setup-nfnl:
	cd "$(HOME)/.config/nvim" && nvim '+lua require("nfnl.api")["compile-all-files"]()'

install-helix: HELIX_BIN  := "$(HOME)/.local/bin/hx"
install-helix: HELIX_PATH := "$(HOME)/.local/opt/helix"
install-helix:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,helix-editor/helix,"^helix[-][0-9.]+[-]x86_64[.]AppImage$$") > $(HELIX_BIN);
	chmod +x $(HELIX_BIN)
else ifeq ($(ARCH),$(filter $(ARCH),aarch64))
	mkdir -p "$(HELIX_PATH)" ;
	$(call get-from-github,helix-editor/helix,"^helix[-][0-9.]+[-]aarch64-linux[.]tar[.]xz$$") \
		| tar -C "$(HELIX_PATH)" --strip-components 1 --xz -xf - ;
	ln -s "$(HELIX_BIN)" "$(HELIX_PATH)/hx"
else
	@echo "Unsupported arch: $(ARCH)"
endif

editors: install-nvim install-hx
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/kakoune.mk

#
# Shell
#

install-fish: ARCHNAME := $(subst amd64,x86_64,$(ARCH))
install-fish:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,fish-shell/fish-shell,"^fish-[0-9.]+-linux-$(ARCHNAME)[.]tar[.]xz$$") \
		| tar -C $(HOME)/.local/bin/ --xz -xf -
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-fish-plugins: install-fzf
	fish -c 'curl -sL https://git.io/fisher | source \
		&& fisher install jorgebucaran/fisher        \
		&& fisher install PatrickF1/fzf.fish'

install-fzf: ARCHNAME := $(subst aarch64,arm64,$(ARCH))
install-fzf:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,junegunn/fzf,"^fzf-[0-9.]+-$(OS)_$(ARCHNAME).tar.gz$$") \
		| tar -C $(HOME)/.local/bin/ --gz -xf -
else
	@echo "Unsupported arch: $(ARCH)"
endif


install-marksman: MARKSMAN := "$(HOME)/.local/bin/marksman"
install-marksman: ARCHNAME := $(subst amd64,x64,$(subst aarch64,arm64,$(ARCH)))
install-marksman:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,artempyanykh/marksman,"^marksman-linux-$(ARCHNAME)$$") \
		 > $(MARKSMAN);
	chmod +x $(MARKSMAN)
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-markdown-oxide:
	cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide


install-bootleg: BOOTLEG := "$(HOME)/.local/bin/bootleg"
install-bootleg:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,retrogradeorbit/bootleg,"^bootleg-[0-9.]+-linux-$(ARCH).tgz$$") \
		| tar --gz --to-stdout -xf - > $(BOOTLEG);
	chmod +x $(BOOTLEG)
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-uv: ARCHNAME := $(subst amd64,x86_64,$(ARCH))
install-uv:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,astral-sh/uv,"^uv-$(ARCHNAME)-unknown-linux-gnu[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --strip-components=1 --gz -xf -
else
	@echo "Unsupported arch: $(ARCH)"
endif


install-docker-compose: DOCKER_COMPOSE := "$(HOME)/.local/bin/docker-compose"
install-docker-compose: ARCHNAME := $(subst amd64,x86_64,$(ARCH))
install-docker-compose:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,docker/compose,"^docker-compose-linux-$(ARCHNAME)$$") \
		> $(DOCKER_COMPOSE)
	chmod +x $(DOCKER_COMPOSE)
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-syncthing: ARCHNAME := $(subst aarch64,amd64,$(ARCH))
install-syncthing:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,syncthing/syncthing,"^syncthing-$(OS)-$(ARCHNAME).*[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --wildcards --strip-components=1 --gz -xf - 'syncthing*/syncthing'
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-sysz:
	$(call get-from-github,joehillen/sysz,"^sysz$$") \
		> $(HOME)/.local/bin/sysz
	chmod +x $(HOME)/.local/bin/sysz

install-xxd:
	$(MAKE) -f $(MAKEFILE_FOLDER)/makefiles/xxd.mk

#
# Lazy tools
#

install-lazygit: ARCHNAME := $(subst amd64,x86_64,$(subst aarch64,arm64,$(ARCH)))
install-lazygit:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,jesseduffield/lazygit,"^lazygit_[0-9.]+_$(OS)_$(ARCHNAME)[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --gz -xf - lazygit
	chmod +x $(HOME)/.local/bin/lazygit
else
	@echo "Unsupported arch: $(ARCH)"
endif

install-lazydocker: ARCHNAME := $(subst amd64,x86_64,$(subst aarch64,arm64,$(ARCH)))
install-lazydocker:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,jesseduffield/lazydocker,"^lazydocker_[0-9.]+_Linux_$(ARCHNAME)[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --gz -xf - lazydocker
	chmod +x $(HOME)/.local/bin/lazydocker
else
	@echo "Unsupported arch: $(ARCH)"
endif

#
# My own scripts.
#

install-scripts:
	$(call get-gist,https://api.github.com/gists/48185612f371a7a0803ad1c329e59933,b16_themes.clj,$(HOME)/.local/bin/b16_themes.clj);
	chmod +x "$(HOME)/.local/bin/b16_themes.clj"

#
# Tools written in Rust
#

install-cargo-tools: install-markdown-oxide
	cargo install --locked age-plugin-yubikey
	cargo install --locked git-delta
	cargo install --locked dysk
	cargo install --locked fd-find
	cargo install --locked htmlq
	cargo install --locked hurl
	cargo install --locked jless
	cargo install --locked lsd
	cargo install --locked procs
	cargo install --locked ripgrep
	cargo install --locked sd
	cargo install --locked tomq
	cargo install --locked tree-sitter-cli
	cargo install --locked xh
	cargo install --locked zoxide

#
# Obsidian
#

install-obsidian: ARCHNAME := $(subst aarch64,arm64,$(ARCH))
install-obsidian:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	curl https://obsidian.md/download \
		| xmllint --html --xpath '//a[i[@icon-name="arrow-down-circle"]]/@href' - 2> /dev/null \
		| sed -r 's/^[ ]*href="(.*)"$/\\1/' \
		| sed -n -r '/Obsidian-[0-9.]+($(ARCHNAME))?[.]AppImage$/p' \
		| xargs curl -O $(HOME)/.local/bin/obsidian
	chmod +x $(HOME)/.local/bin/obsidian
else
	@echo "Unsupported arch: $(ARCH)"
endif

#
# ratarmount
#

install-ratarmount: RATARMOUNT := "$(HOME)/.local/bin/ratarmount"
install-ratarmount: ARCHNAME := $(subst amd64,x86_64,$(ARCH))
install-ratarmount:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,mxmlnkn/ratarmount,"^ratarmount-[0-9.]+-$(ARCHNAME).AppImage$$") > $(RATARMOUNT);
	chmod +x $(RATARMOUNT)
else
	@echo "Unsupported arch: $(ARCH)"
endif

#
# nnn file manager and it's plugins
#

install-nnn: NNN := $(HOME)/.local/bin/nnn
install-nnn:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,jarun/nnn,"^nnn-nerd-static-[0-9.]+[.]x86_64[.]tar[.]gz$$") \
		| tar --gz --to-stdout -xf - > $(NNN);
	chmod +x "$(NNN)"
else
	@echo "Unsupported arch: $(ARCH)"
endif


install-nnn-plugins: install-nnn
	mkdir -p "$(HOME)/.config/nnn/plugins"
	echo autojump dragdrop fzplug preview-tabbed preview-tui rsynccp suedit | xargs -n 1 -I {} curl -O -L --output-dir "$(HOME)/.config/nnn/plugins/" "https://github.com/jarun/nnn/raw/refs/heads/master/plugins/{}"
	chmod +x "$(HOME)/.config/nnn/plugins/*"

install-crossmacro: BINARY := $(HOME)/.local/bin/crossmacro
install-crossmacro: ARCHNAME := $(subst amd64,x86_64,$(ARCH))
install-crossmacro:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,alper-han/CrossMacro,"^CrossMacro-[0-9.]+-$(ARCHNAME).AppImage$$") > $(BINARY);
	chmod +x $(BINARY)
else
	@echo "Unsupported arch: $(ARCH)"
endif
