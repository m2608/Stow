nvim:
	cd ${HOME}/.config/nvim && nvim '+lua require("nfnl.api")["compile-all-files"]()'

symlinks:
	stow --target=$$HOME --restow */

all: symlinks nvim

delete:
	stow --target=$$HOME --delete */
