define get-github-url
	curl "https://api.github.com/repos/$(1)/releases" \
		| jq -r '[.[] | select(.prerelease==false)] | sort_by(.created_at) | reverse | .[0] .assets[] | select(.name | test($(2))) | .browser_download_url'
endef

define get-from-github
	curl "https://api.github.com/repos/$(1)/releases" \
		| jq -r '[.[] | select(.prerelease==false)] | sort_by(.created_at) | reverse | .[0] .assets[] | select(.name | test($(2))) | .browser_download_url' \
		| xargs -n 1 curl -L
endef

define get-gist
	curl -Ls $(1) | jq -r '.files["$(2)"] .content' > $(3)
endef
