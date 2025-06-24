#!/bin/sh

get_resource() {
    name="$1"
    xrdb -query | sed -r -n "/^$name:/ s/$name:[\\s\\t]+// p"
}

magick=$(command -v magick || command -v convert) || exit 1

# window title
title="layout"

# screen width
sw=$(bspc query -M \
    | parallel -k -n 1 bspc query -T -m {} \
    | jq --slurp 'sort_by(.rectangle | .x) | .[0] .rectangle .width')

# get settings from resources
font=$(get_resource "bspwm-message[.]font")
bg=$(get_resource "bspwm-message[.]background")
fg=$(get_resource "bspwm-message[.]foreground")

# default settings
: "${font:='Terminus:size=16'}"
: "${bg:='#432d59'}"
: "${fg:='#00ff00'}"

# get font file and size for magick
fontfile=$(fc-match -f "%{file}" "$font")
fontsize=$(fc-match -f "%{size}" "$font")

# get screen dpi
dpi=$(xdpyinfo | sed -n -r '/^[ ]*resolution:[ ]+[0-9]+x[0-9]+ dots/ s/^[ ]*resolution:[ ]+([0-9]+)x([0-9]+) dots .*/(\1+\2)\/2/p' | bc)

# time message size
size=$("$magick" -density $dpi -font "$fontfile" -pointsize $fontsize label:XX -format "%wx%h" info:)

mw=$(echo $size | cut -d 'x' -f 1)
mh=$(echo $size | cut -d 'x' -f 2)

while true; do 
    xkb-switch -p | tr a-z A-Z
    xkb-switch --wait
done | dzen2 \
    -e "button1=exec:xkb-switch -n" \
    -title-name "$title" \
    -p 0 -bg "$bg" -fg "$fg" -fn "$font" -x $((sw-mw)) -w $mw -h $mh
