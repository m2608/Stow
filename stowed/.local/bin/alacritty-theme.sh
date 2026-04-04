#!/bin/sh

config="$HOME/.config/alacritty/alacritty.toml"
themes="$HOME/Themes/output/base16-alacritty/colors"

self=$(basename "$0")

help='Sets theme for alacritty. Themes folder: '$themes'
Usage: '$self' <theme>
'

test -n "$1" || { echo "$help" ; exit 1; }
theme="${themes}/$1.toml"

command -v tomq > /dev/null || { echo "tomq tool required"; exit 1; }

test -f "$theme" || { printf "Theme file not found: %s\n" "$theme" ; exit 1; }

tomq --input-files "$config" "$theme" | jq -s '.[0] * .[1]' | tomq --pp -T | sponge "$config"
