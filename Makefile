symlinks:
	stow --target=$$HOME --restow */

all: symlinks

delete:
	stow --target=$$HOME --delete */
