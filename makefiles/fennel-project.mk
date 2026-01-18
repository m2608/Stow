TOOLCHAIN := .toolchain
BUILDDIR  := .build

all: lua luarocks fennel deps cljlib ignore

clean:
	rm -rf $(BUILDDIR) $(TOOLCHAIN)

fetch-lua: URL := https://www.lua.org
fetch-lua:
	mkdir -p $(BUILDDIR)
	curl $(URL)/versions.html \
		| xmllint --html --xpath '//a/@href' - \
		| sed -r -n 's/^[ ]*href="(.*\/lua-5[.]4[.][0-9]+[.]tar[.]gz)"$$/\1/p' \
		| xargs -I {} curl $(URL)/{} \
		| tar -C $(BUILDDIR) --gz -xf -
lua: fetch-lua
	make -C $(BUILDDIR)/lua-* INSTALL_TOP=$(PWD)/$(TOOLCHAIN) all install

fetch-luarocks: REPO := https://github.com/luarocks/luarocks
fetch-luarocks:
	mkdir -p $(BUILDDIR)
	git ls-remote --tags $(REPO) \
		| sed -r -n 's/^.*\/(v[0-9]+[.][0-9]+[.][0-9]+)$$/\1/p' \
		| sort -V \
		| tail -n 1 \
		| xargs -I {} git -C $(BUILDDIR) clone -b {} --single-branch $(REPO)

luarocks: fetch-luarocks
	cd $(BUILDDIR)/luarocks && ./configure --prefix=$(PWD)/$(TOOLCHAIN) --with-lua=$(PWD)/$(TOOLCHAIN)
	make -C $(BUILDDIR)/luarocks install

fennel: URL := https://fennel-lang.org/downloads/
fennel: BIN := $(TOOLCHAIN)/bin/fennel
fennel:
	mkdir -p $(TOOLCHAIN)/bin
	curl $(URL) \
		| xmllint --html --xpath '//a/@href' - \
		| sed -r -n 's/^[ ]*href="(.*-[0-9.]+)"/\1/p' \
		| sort -V \
		| tail -n 1 \
		| xargs -I {} curl --output $(BIN) $(URL){}
	chmod +x $(BIN)

deps: API := https://gitlab.com/api/v4/projects/andreyorst%2fdeps.fnl
deps: URL := https://gitlab.com/andreyorst/deps.fnl
deps: BIN := $(TOOLCHAIN)/bin/deps
deps:
	mkdir -p $(TOOLCHAIN)/bin
	curl $(API)/repository/tags \
		| jq -r 'sort_by(.commit.created_at) | map(.name) | last' \
		| xargs -I {} curl --output $(BIN) $(URL)/-/raw/{}/deps
	chmod +x $(BIN)

cljlib: API := https://gitlab.com/api/v4/projects/andreyorst%2ffennel-cljlib
cljlib: URL := https://gitlab.com/andreyorst/fennel-cljlib
cljlib:
	curl $(API)/repository/tags \
		| jq -r 'sort_by(.commit.created_at) | last | .commit.id' \
		| xargs -I {} echo '{:deps {"io.gitlab.andreyorst/fennel-cljlib" {:type :git :sha "{}"}}}' \
		> deps.fnl

ignore:
	printf "%s\n%s\n" $(TOOLCHAIN)/ $(BUILDDIR)/ > .gitignore
