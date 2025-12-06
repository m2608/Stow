CURRENT_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))

include $(CURRENT_FOLDER)/functions.mk

fetch-iosevka:
	$(call get-github-url,be5invis/Iosevka,"PkgTTF-Iosevka.*[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-pragmasevka:
	$(call get-github-url,shytikov/pragmasevka,"^Pragmasevka_NF[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-ioskeley:
	$(call get-github-url,ahatem/IoskeleyMono,"^IoskeleyMono-TTF-Hinted.zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-victor:
	curl -L -O --fail "https://rubjo.github.io/victor-mono/VictorMonoAll.zip"

fetch-sudo:
	$(call get-github-url,jenskutilek/sudo-font,"^sudo[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-departure:
	$(call get-github-url,rektdeckard/departure-mono,"^DepartureMono.*[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-apl386:
	curl -L -O https://abrudz.github.io/APL386/APL386.ttf

all: fetch-iosevka fetch-pragmasevka fetch-ioskeley fetch-victor fetch-sudo fetch-departure fetch-apl386
