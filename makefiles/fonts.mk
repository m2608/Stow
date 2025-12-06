fetch-font-iosevka:
	$(call get-github-url,be5invis/Iosevka,"PkgTTF-Iosevka.*[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-font-pragmasevka:
	$(call get-github-url,shytikov/pragmasevka,"^Pragmasevka_NF[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-font-ioskeley:
	$(call get-github-url,ahatem/IoskeleyMono,"^IoskeleyMono-TTF-Hinted.zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-font-victor:
	curl -L -O --fail "https://rubjo.github.io/victor-mono/VictorMonoAll.zip"

fetch-font-sudo:
	$(call get-github-url,jenskutilek/sudo-font,"^sudo[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-font-departure:
	$(call get-github-url,rektdeckard/departure-mono,"^DepartureMono.*[.]zip$$") \
		| xargs -n 1 curl -L -O --fail

fetch-font-apl386:
	curl -L -O https://abrudz.github.io/APL386/APL386.ttf

all: fetch-font-iosevka fetch-font-pragmasevka fetch-font-ioskeley fetch-font-victor fetch-font-sudo fetch-font-departure
