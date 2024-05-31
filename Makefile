NVIM := "$(HOME)/.local/bin/nvim"
HELIX := "$(HOME)/.local/bin/hx"
BABASHKA := "$(HOME)/.local/bin/bb"
CQ := "$(HOME)/.local/bin/cq"
JET := "$(HOME)/.local/bin/jet"

define get-from-github
	xh "https://api.github.com/repos/$(1)/releases" \
		| jq -r '[.[] | select(.prerelease==false)] | sort_by(.created_at) | reverse | .[0] .assets[] | select(.name | test($(2))) | .browser_download_url' \
		| parallel xh -F get "{}"
endef

symlinks:
	stow --target=$(HOME) --restow */

fisher:
	fish -c 'curl -sL https://git.io/fisher | source \
		&& fisher install jorgebucaran/fisher        \
		&& fisher install orefalo/grc                \
		&& fisher install PatrickF1/fzf.fish'

install-nvim:
	$(call get-from-github,neovim/neovim-releases,"^nvim.appimage$$") > $(NVIM);
	chmod +x $(NVIM)

install-hx:
	$(call get-from-github,helix-editor/helix,"[.]AppImage$$") > $(HELIX);
	chmod +x $(HELIX)

install-bb:
	$(call get-from-github,babashka/babashka,"^babashka-[0-9.]+-linux-amd64-static.tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(BABASHKA);
	chmod +x $(BABASHKA)

install-cq:
	$(call get-from-github,markus-wa/cq,"^cq-native-linux$$") > $(CQ);
	chmod +x $(CQ)

install-jet:
	$(call get-from-github,borkdude/jet,"^jet-[0-9.]+-linux-amd64.tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(JET);
	chmod +x $(JET)

all: symlinks

delete:
	stow --target=$(HOME) --delete */
