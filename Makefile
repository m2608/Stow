NVIM           := "$(HOME)/.local/bin/nvim"
HELIX          := "$(HOME)/.local/bin/hx"
MARKSMAN       := "$(HOME)/.local/bin/marksman"
BOOTLEG        := "$(HOME)/.local/bin/bootleg"
KAK_LSP        := "$(HOME)/.local/bin/kak-lsp"
DOCKER_COMPOSE := "$(HOME)/.local/bin/docker-compose"

MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/makefiles/functions.mk

#
# GNU tools
#

install-make:
	$(MAKE) -f makefiles/gnu.mk NAME=make CONFIGURE_PARAMS="--with-guile"

install-stow:
	$(MAKE) -f makefiles/gnu.mk NAME=stow

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
	$(MAKE) -f makefiles/fonts.mk

#
# Clojure tools
#

clojure-tools:
	$(MAKE) -f makefiles/clojure-tools.mk


install-fish:
	$(call get-from-github,fish-shell/fish-shell,"^fish-static-amd64-[0-9.]+.tar.xz$$") \
		| tar -C $(HOME)/.local/bin/ --xz -xf -

install-fish-plugins: install-fzf
	fish -c 'curl -sL https://git.io/fisher | source \
		&& fisher install jorgebucaran/fisher        \
		&& fisher install PatrickF1/fzf.fish'

install-fzf:
	$(call get-from-github,junegunn/fzf,"^fzf-[0-9.]+-linux_amd64.tar.gz$$") \
		| tar -C $(HOME)/.local/bin/ --gz -xf -

install-nvim:
	$(call get-from-github,neovim/neovim-releases,"^nvim-linux-x86_64[.]appimage$$") > $(NVIM);
	chmod +x $(NVIM)

install-hx:
	$(call get-from-github,helix-editor/helix,"[.]AppImage$$") > $(HELIX);
	chmod +x $(HELIX)

install-marksman:
	$(call get-from-github,artempyanykh/marksman,"^marksman-linux-x64$$") \
		 > $(MARKSMAN);
	chmod +x $(MARKSMAN)

install-bootleg:
	$(call get-from-github,retrogradeorbit/bootleg,"^bootleg-[0-9.]+-linux-amd64.tgz$$") \
		| tar --gz --to-stdout -xf - > $(BOOTLEG);
	chmod +x $(BOOTLEG)

install-kak-lsp:
	$(call get-from-github,kakoune-lsp/kakoune-lsp,"^kakoune-lsp-v[0-9.]+-x86_64-unknown-linux-musl[.]tar[.]gz$$") \
		| tar --gz --to-stdout -xf - kak-lsp > $(KAK_LSP);
	chmod +x $(KAK_LSP)

install-uv:
	$(call get-from-github,astral-sh/uv,"^uv-x86_64-unknown-linux-gnu[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --strip-components=1 --gz -xf -

install-docker-compose:
	$(call get-from-github,docker/compose,"^docker-compose-linux-x86_64$$") \
		> $(DOCKER_COMPOSE)
	chmod +x $(DOCKER_COMPOSE)

install-markdown-oxide:
	cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide

install-syncthing:
	$(call get-from-github,syncthing/syncthing,"^syncthing-linux-amd64.*[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --wildcards --strip-components=1 --gz -xf - 'syncthing*/syncthing'

install-sysz:
	$(call get-from-github,joehillen/sysz,"^sysz$$") \
		> $(HOME)/.local/bin/sysz
	chmod +x $(HOME)/.local/bin/sysz

#
# Lazy tools
#

install-lazydocker:
	$(call get-from-github,jesseduffield/lazygit,"^lazygit_[0-9.]+_Linux_x86_64.tar.gz$$") \
		| tar -C $(HOME)/.local/bin --gz -xf - lazygit
	chmod +x $(HOME)/.local/bin/lazygit

install-lazydocker:
	$(call get-from-github,jesseduffield/lazydocker,"^lazydocker_[0-9.]+_Linux_x86_64.tar.gz$$") \
		| tar -C $(HOME)/.local/bin --gz -xf - lazydocker
	chmod +x $(HOME)/.local/bin/lazydocker

#
# My own scripts.
#

install-scripts:
	$(call get-gist,https://api.github.com/gists/48185612f371a7a0803ad1c329e59933,b16_themes.clj,$(HOME)/.local/bin/b16_themes.clj);
	chmod +x "$(HOME)/.local/bin/b16_themes.clj"

install-cargo-essentials: install-markdown-oxide

install-obsidian:
	curl https://obsidian.md/download | xmllint --html --xpath '//a[i[@icon-name="arrow-down-circle"]]/@href' - 2> /dev/null | sed -r 's/^[ ]*href="(.*)"$/\\1/' | sed -n -r '/Obsidian-[0-9.]+[.]AppImage$/p' | xargs curl -O $(HOME)/.local/bin/obsidian
	chmod +x $(HOME)/.local/bin/obsidian

setup-nfnl:
	cd "$(HOME)/.config/nvim" && nvim '+lua require("nfnl.api")["compile-all-files"]()'

install-nnn-plugins:
	mkdir -p "$(HOME)/.config/nnn/plugins"
	echo autojump dragdrop fzplug preview-tabbed preview-tui rsynccp suedit | xargs -n 1 -I {} curl -O -L --output-dir "$(HOME)/.config/nnn/plugins/" "https://github.com/jarun/nnn/raw/refs/heads/master/plugins/{}"
	chmod +x "$(HOME)/.config/nnn/plugins/*"

all: symlinks

