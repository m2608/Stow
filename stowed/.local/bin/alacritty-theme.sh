#!/bin/sh

# Определяем путь к файлу (для случаев, когда используется символическая ссылка).
config=$(realpath "$HOME/.config/alacritty/alacritty.toml")

themes="$HOME/Themes/output/base16-alacritty/colors"

self=$(basename "$0")

help='Sets theme for alacritty. Themes folder: '$themes'
Usage: '$self' <theme>
'

test -n "$1" || { echo "$help" ; exit 1; }
theme="${themes}/$1.toml"

command -v tomq > /dev/null || { echo "tomq tool required"; exit 1; }

test -f "$theme" || { printf "Theme file not found: %s\n" "$theme" ; exit 1; }

data=$(tomq --input-files "$config" "$theme" \
    | jq -s '.[0] * .[1]' \
    | tomq --pp -T)

# Если файл не удалить, то при перенаправлении вывода данные будут записаны в файл
# с тем же inode. В таких случаях alacritty почему-то не отслеживает изменение конфига.
rm "$config"
echo "$data" > "$config"
