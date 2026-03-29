MAKEFILE_FOLDER := $(shell dirname $(lastword $(MAKEFILE_LIST)))
include $(MAKEFILE_FOLDER)/functions.mk

OUTPUT_FOLDER := "$(HOME)/.fonts"

all: iosevka pragmasevka ioskeley victor sudo departure apl386

iosevka:
	$(call get-github-url,be5invis/Iosevka,"^PkgTTF-Iosevka(Term(SS[0-9]+)?|SS[0-9]+|Aile|Etoile|Slab)?-[0-9.]+[.]zip$$") \
		| xargs -I {} sh -c "curl -L --fail {} | bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'"

pragmasevka:
	$(call get-github-url,shytikov/pragmasevka,"^Pragmasevka_NF[.]zip$$") \
		| xargs -n 1 curl -s -L --fail \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

ioskeley:
	$(call get-github-url,ahatem/IoskeleyMono,"^IoskeleyMono-TTF-Hinted.zip$$") \
		| xargs -n 1 curl -s -L --fail \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

victor:
	curl -s -L --fail "https://rubjo.github.io/victor-mono/VictorMonoAll.zip" \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

sudo:
	$(call get-github-url,jenskutilek/sudo-font,"^sudo[.]zip$$") \
		| xargs -n 1 curl -s -L --fail \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

departure:
	$(call get-github-url,rektdeckard/departure-mono,"^DepartureMono.*[.]zip$$") \
		| xargs -n 1 curl -s -L --fail \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.otf'

apl386:
	curl -L -O --output-dir $(OUTPUT_FOLDER) https://abrudz.github.io/APL386/APL386.ttf

julia:
	$(call get-github-url,cormullion/juliamono,"^JuliaMono-ttf[.]zip$$") \
		| xargs -n 1 curl -s -L --fail \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

jetbrains:
	curl -L https://www.jetbrains.com/lp/mono/ \
		| xmllint --html --xpath '//a[contains(@class, "button-download-font")]/@href' - 2> /dev/null \
		| sed -r -n 's/^[ ]*href="(.*)"/\1/p' \
		| sed -n 1p \
		| xargs -n 1 curl -L \
		| bsdtar -C $(OUTPUT_FOLDER) -xf - -s '|.*/||' '*.ttf'

bqn:
	curl -L -O --output-dir $(OUTPUT_FOLDER) \
		https://github.com/dzaima/BQN386/raw/refs/heads/master/BQN386.ttf

nrk:
	$(call get-github-url,N-R-K/NRK-Mono,"^NRK-Mono-v[0-9.]+[.]tar[.]zst$$") \
		| xargs -n 1 curl -s -L --fail \
		| tar -C $(OUTPUT_FOLDER) --zstd --strip-components 1 -xf - '*.ttf'

iosvmata:
	$(call get-github-url,N-R-K/Iosvmata,"^Iosvmata-v[0-9.]+[.]tar[.]zst$$") \
		| xargs -n 1 curl -s -L --fail \
		| tar -C $(OUTPUT_FOLDER) --zstd --strip-components 2 -xf - '*.ttf'
