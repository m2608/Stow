MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

OUTPUT_FOLDER := "$(HOME)/.fonts"

all: iosevka pragmasevka ioskeley victor sudo departure apl386

iosevka:
	$(call get-github-url,be5invis/Iosevka,"PkgTTF-Iosevka(Term|Aile|Etoile|Slab)?-[0-9.]+[.]zip$$") \
		| xargs -I{} sh -c 'curl -s -L --fail {} | unzip -d "$(OUTPUT_FOLDER)" -- - "*.ttf"'

pragmasevka:
	$(call get-github-url,shytikov/pragmasevka,"^Pragmasevka_NF[.]zip$$") \
		| xargs -n 1 curl -s -L --fail | unzip -d "$(OUTPUT_FOLDER)" -- - "*.ttf"

ioskeley:
	$(call get-github-url,ahatem/IoskeleyMono,"^IoskeleyMono-TTF-Hinted.zip$$") \
		| xargs -n 1 curl -s -L --fail | unzip -j -d "$(OUTPUT_FOLDER)" -- - "*.ttf"

victor:
	curl -s -L --fail "https://rubjo.github.io/victor-mono/VictorMonoAll.zip" \
		| unzip -j -d "$(OUTPUT_FOLDER)" -- - "*.ttf"

sudo:
	$(call get-github-url,jenskutilek/sudo-font,"^sudo[.]zip$$") \
		| xargs -n 1 curl -s -L --fail | unzip -j -d "$(OUTPUT_FOLDER)" -- - "*.ttf"

departure:
	$(call get-github-url,rektdeckard/departure-mono,"^DepartureMono.*[.]zip$$") \
		| xargs -n 1 curl -s -L --fail | unzip -d "$(OUTPUT_FOLDER)" -- - "*.ttf"

apl386:
	curl -L -O --output-dir "$(OUTPUT_FOLDER)" https://abrudz.github.io/APL386/APL386.ttf
