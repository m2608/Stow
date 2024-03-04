symlinks:
	stow --target=$$HOME --restow */

fisher:
	fish -c 'curl -sL https://git.io/fisher | source \
		&& fisher install jorgebucaran/fisher        \
		&& fisher install orefalo/grc                \
		&& fisher install PatrickF1/fzf.fish'

all: symlinks

delete:
	stow --target=$$HOME --delete */
