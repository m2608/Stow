MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk


babashka: BABASHKA := "$(HOME)/.local/bin/bb"
babashka:
	$(call get-from-github,babashka/babashka,"^babashka-[0-9.]+-linux-amd64-static.tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(BABASHKA);
	chmod +x $(BABASHKA)


cq: CQ := "$(HOME)/.local/bin/cq"
cq:
	$(call get-from-github,markus-wa/cq,"^cq-native-linux$$") > $(CQ);
	chmod +x $(CQ)


jet: JET := "$(HOME)/.local/bin/jet"
jet:
	$(call get-from-github,borkdude/jet,"^jet-[0-9.]+-linux-amd64.tar.gz$$") \
		| tar --gz --to-stdout -xf - > $(JET);
	chmod +x $(JET)


clojure-lsp: CLOJURE_LSP := "$(HOME)/.local/bin/clojure-lsp"
clojure-lsp:
	$(call get-from-github,clojure-lsp/clojure-lsp,"^clojure-lsp-native-static-linux-amd64.zip$$") \
		| bsdtar -xO -f - > $(CLOJURE_LSP);
	chmod +x $(CLOJURE_LSP)


clj-kondo: CLJ_KONDO := "$(HOME)/.local/bin/clj-kondo"
clj-kondo:
	$(call get-from-github,clj-kondo/clj-kondo,"^clj-kondo-[0-9.]+-linux-amd64.zip$$") \
		| bsdtar -xO -f - > $(CLJ_KONDO);
	chmod +x $(CLJ_KONDO)


cljfmt: CLJFMT := "$(HOME)/.local/bin/cljfmt"
cljfmt: CLJFMT_JAR := "$(HOME)/.local/opt/cljfmt/cljfmt.jar"
cljfmt:
	mkdir -p `dirname $(CLJFMT_JAR)`;
	$(call get-from-github,weavejester/cljfmt,"^cljfmt-[0-9.]+-standalone.jar$$") \
		> $(CLJFMT_JAR);
	printf "#!/bin/sh\n\njava -jar $(CLJFMT_JAR) $$\@\n" > $(CLJFMT); 
	chmod +x $(CLJFMT)


all: babashka cq jet clojure-lsp clj-kondo cljfmt
