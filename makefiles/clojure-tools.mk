MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

ARCH := $(shell uname -m | tr A-Z a-z)
OS   := $(shell uname -s | tr A-Z a-z)

all: babashka cq jet clojure-lsp clj-kondo cljfmt

babashka: BABASHKA := "$(HOME)/.local/bin/bb"
babashka:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,babashka/babashka,"^babashka-[0-9.]+-linux-$(ARCH)-static.tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(BABASHKA);
	chmod +x $(BABASHKA)
else
	@echo "Unsupported arch: $(ARCH)"
endif


cq: CQ := "$(HOME)/.local/bin/cq"
cq:
ifeq ($(ARCH),$(filter $(ARCH),amd64))
	$(call get-from-github,markus-wa/cq,"^cq-native-linux$$") > $(CQ);
	chmod +x $(CQ)
else
	@echo "Unsupported arch: $(ARCH)"
endif


jet: JET := "$(HOME)/.local/bin/jet"
jet:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,borkdude/jet,"^jet-[0-9.]+-linux-$(ARCH).tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(JET);
	chmod +x $(JET)
else
	@echo "Unsupported arch: $(ARCH)"
endif


clojure-lsp: CLOJURE_LSP := "$(HOME)/.local/bin/clojure-lsp"
clojure-lsp:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,clojure-lsp/clojure-lsp,"^clojure-lsp-native-static-linux-$(ARCH).zip$$") \
		| bsdtar -xO -f - > $(CLOJURE_LSP);
	chmod +x $(CLOJURE_LSP)
else
	@echo "Unsupported arch: $(ARCH)"
endif


clj-kondo: CLJ_KONDO := "$(HOME)/.local/bin/clj-kondo"
clj-kondo:
ifeq ($(ARCH),$(filter $(ARCH),amd64 aarch64))
	$(call get-from-github,clj-kondo/clj-kondo,"^clj-kondo-[0-9.]+-linux-$(ARCH).zip$$") \
		| bsdtar -xO -f - > $(CLJ_KONDO);
	chmod +x $(CLJ_KONDO)
else
	@echo "Unsupported arch: $(ARCH)"
endif


cljfmt: CLJFMT := "$(HOME)/.local/bin/cljfmt"
cljfmt: CLJFMT_JAR := "$(HOME)/.local/opt/cljfmt/cljfmt.jar"
cljfmt:
	mkdir -p `dirname $(CLJFMT_JAR)`;
	$(call get-from-github,weavejester/cljfmt,"^cljfmt-[0-9.]+-standalone.jar$$") \
		> $(CLJFMT_JAR);
	printf "#!/bin/sh\n\njava -jar $(CLJFMT_JAR) $$\@\n" > $(CLJFMT); 
	chmod +x $(CLJFMT)
