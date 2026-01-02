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

#
# Editors
#

install-nvim: NVIM := "$(HOME)/.local/bin/nvim"
install-nvim:
	$(call get-from-github,neovim/neovim-releases,"^nvim-linux-x86_64[.]appimage$$") > $(NVIM);
	chmod +x $(NVIM)

setup-nfnl:
	cd "$(HOME)/.config/nvim" && nvim '+lua require("nfnl.api")["compile-all-files"]()'

install-helix: HELIX := "$(HOME)/.local/bin/hx"
install-helix:
	$(call get-from-github,helix-editor/helix,"[.]AppImage$$") > $(HELIX);
	chmod +x $(HELIX)

editors: install-nvim install-hx
	$(MAKE) -f makefiles/kakoune.mk

#
# Shell
#

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


install-marksman: MARKSMAN := "$(HOME)/.local/bin/marksman"
install-marksman:
	$(call get-from-github,artempyanykh/marksman,"^marksman-linux-x64$$") \
		 > $(MARKSMAN);
	chmod +x $(MARKSMAN)

install-markdown-oxide:
	cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide


install-bootleg: BOOTLEG := "$(HOME)/.local/bin/bootleg"
install-bootleg:
	$(call get-from-github,retrogradeorbit/bootleg,"^bootleg-[0-9.]+-linux-amd64.tgz$$") \
		| tar --gz --to-stdout -xf - > $(BOOTLEG);
	chmod +x $(BOOTLEG)

install-uv:
	$(call get-from-github,astral-sh/uv,"^uv-x86_64-unknown-linux-gnu[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --strip-components=1 --gz -xf -


install-docker-compose: DOCKER_COMPOSE := "$(HOME)/.local/bin/docker-compose"
install-docker-compose:
	$(call get-from-github,docker/compose,"^docker-compose-linux-x86_64$$") \
		> $(DOCKER_COMPOSE)
	chmod +x $(DOCKER_COMPOSE)

install-syncthing:
	$(call get-from-github,syncthing/syncthing,"^syncthing-linux-amd64.*[.]tar[.]gz$$") \
		| tar -C $(HOME)/.local/bin --wildcards --strip-components=1 --gz -xf - 'syncthing*/syncthing'

install-sysz:
	$(call get-from-github,joehillen/sysz,"^sysz$$") \
		> $(HOME)/.local/bin/sysz
	chmod +x $(HOME)/.local/bin/sysz

install-xxd:
	$(MAKE) -f makefiles/xxd.mk

#
# Lazy tools
#

install-lazygit:
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

#
# Tools written in Rust
#

install-cargo-tools: install-markdown-oxide
	cargo install --locked git-delta
	cargo install --locked dysk
	cargo install --locked htmlq
	cargo install --locked hurl
	cargo install --locked jless
	cargo install --locked lsd
	cargo install --locked procs
	cargo install --locked sd
	cargo install --locked tomq
	cargo install --locked tree-sitter-cli
	cargo install --locked xh
	cargo install --locked zoxide

#
# Obsidian
#

install-obsidian:
	curl https://obsidian.md/download | xmllint --html --xpath '//a[i[@icon-name="arrow-down-circle"]]/@href' - 2> /dev/null | sed -r 's/^[ ]*href="(.*)"$/\\1/' | sed -n -r '/Obsidian-[0-9.]+[.]AppImage$/p' | xargs curl -O $(HOME)/.local/bin/obsidian
	chmod +x $(HOME)/.local/bin/obsidian

#
# ratarmount
#

install-ratarmount: RATARMOUNT := "$(HOME)/.local/bin/ratarmount"
install-ratarmount:
	$(call get-from-github,mxmlnkn/ratarmount,"^ratarmount-[0-9.]+-x86_64.AppImage$$") > $(RATARMOUNT);
	chmod +x $(RATARMOUNT)

#
# nnn file manager and it's plugins
#

install-nnn: NNN := $(HOME)/.local/bin/nnn
install-nnn:
	$(call get-from-github,jarun/nnn,"^nnn-nerd-static-[0-9.]+[.]x86_64[.]tar[.]gz$$") \
		| tar --gz --to-stdout -xf - > $(NNN);
	chmod +x "$(NNN)"


install-nnn-plugins: install-nnn
	mkdir -p "$(HOME)/.config/nnn/plugins"
	echo autojump dragdrop fzplug preview-tabbed preview-tui rsynccp suedit | xargs -n 1 -I {} curl -O -L --output-dir "$(HOME)/.config/nnn/plugins/" "https://github.com/jarun/nnn/raw/refs/heads/master/plugins/{}"
	chmod +x "$(HOME)/.config/nnn/plugins/*"

all: symlinks

