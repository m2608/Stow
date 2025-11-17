#!/bin/sh

config="$HOME/.config/alacritty/alacritty.toml"
themes="$HOME/Themes/alacritty/colors"

self=$(basename "$0")

help='Sets theme for alacritty. Themes folder: '$themes'
Usage: '$self' <theme>
'

test -n "$1" || { echo "$help" ; exit 1; }
theme="${themes}/base16-$1.toml"

command -v tomq > /dev/null || { echo "tomq tool required"; exit 1; }

test -f "$theme" || { printf "Theme file not found: %s\n" "$theme" ; exit 1; }

cat "$config" \
| tomq --pp -R '(.general.import[] | select(test("/Themes/"))) = $theme' -- --arg theme "$theme" \
| sponge "$config"
