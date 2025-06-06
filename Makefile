NVIM        := "$(HOME)/.local/bin/nvim"
HELIX       := "$(HOME)/.local/bin/hx"
BABASHKA    := "$(HOME)/.local/bin/bb"
CQ          := "$(HOME)/.local/bin/cq"
JET         := "$(HOME)/.local/bin/jet"
MARKSMAN    := "$(HOME)/.local/bin/marksman"
CLOJURE_LSP := "$(HOME)/.local/bin/clojure-lsp"
CLJ_KONDO   := "$(HOME)/.local/bin/clj-kondo"
CLJFMT      := "$(HOME)/.local/bin/cljfmt"
CLJFMT_JAR  := "$(HOME)/.local/opt/cljfmt/cljfmt.jar"
BOOTLEG     := "$(HOME)/.local/bin/bootleg"
KAK_LSP     := "$(HOME)/.local/bin/kak-lsp"

define get-from-github
	xh "https://api.github.com/repos/$(1)/releases" \
		| jq -r '[.[] | select(.prerelease==false)] | sort_by(.created_at) | reverse | .[0] .assets[] | select(.name | test($(2))) | .browser_download_url' \
		| xargs -I{} xh -F get "{}"
endef

define get-gist
	curl -Ls $(1) | jq -r '.files["$(2)"] .content' > $(3)
endef

symlinks:
	stow --target=$(HOME) --restow */

install-fish:
	$(call get-from-github,fish-shell/fish-shell,"^fish-static-amd64-[0-9.]+.tar.xz$$") \
		| tar -C $(HOME)/.local/bin/ --xz -xf -

fisher:
	fish -c 'curl -sL https://git.io/fisher | source \
		&& fisher install jorgebucaran/fisher        \
		&& fisher install orefalo/grc                \
		&& fisher install PatrickF1/fzf.fish'

install-nvim:
	$(call get-from-github,neovim/neovim-releases,"^nvim-linux-x86_64[.]appimage$$") > $(NVIM);
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

install-marksman:
	$(call get-from-github,artempyanykh/marksman,"^marksman-linux-x64$$") \
		 > $(MARKSMAN);
	chmod +x $(MARKSMAN)

install-clojure-lsp:
	$(call get-from-github,clojure-lsp/clojure-lsp,"^clojure-lsp-native-linux-amd64.zip$$") \
		| bsdtar -xO - > $(CLOJURE_LSP);
	chmod +x $(CLOJURE_LSP)

install-clj-kondo:
	$(call get-from-github,clj-kondo/clj-kondo,"^clj-kondo-[0-9.]+-linux-amd64.zip$$") \
		| bsdtar -xO - > $(CLJ_KONDO);
	chmod +x $(CLJ_KONDO)

install-cljfmt:
	mkdir -p `dirname $(CLJFMT_JAR)`;
	$(call get-from-github,weavejester/cljfmt,"^cljfmt-[0-9.]+-standalone.jar$$") \
		> $(CLJFMT_JAR);
	printf "#!/bin/sh\n\njava -jar $(CLJFMT_JAR) $$\@\n" > $(CLJFMT); 
	chmod +x $(CLJFMT)

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

install-scripts:
	$(call get-gist,https://api.github.com/gists/48185612f371a7a0803ad1c329e59933,b16_themes.clj,$(HOME)/.local/bin/b16_themes.clj);
	chmod +x "$(HOME)/.local/bin/b16_themes.clj"

fetch-iosevka:
	curl -s 'https://api.github.com/repos/be5invis/Iosevka/releases/latest' | jq -r ".assets[] | .browser_download_url" | grep PkgTTC-Iosevka | xargs -n 1 curl -L -O --fail

all: symlinks

delete:
	stow --target=$(HOME) --delete */
