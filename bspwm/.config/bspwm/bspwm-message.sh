#!/bin/sh

test -n "$1" || exit 0

# check for required tools
command -v dzen2 > /dev/null || exit 1
magick=$(command -v magick || command -v convert) || exit 1

get_resource() {
    name="$1"
    xrdb -query | sed -r -n "/^$name:/ s/$name:[\\s\\t]+// p"
}

message="$1"

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

# message size
size=$("$magick" -density $dpi -font "$fontfile" -pointsize $fontsize label:"$message" -format "%wx%h" info:)

mw=$(echo $size | cut -d 'x' -f 1)
mh=$(echo $size | cut -d 'x' -f 2)

# screen size and position
rect=$(bspc query -T -m focused | jq .rectangle)

sx=$(jq -n --argjson rect "$rect" '$rect .x')
sy=$(jq -n --argjson rect "$rect" '$rect .y')
sw=$(jq -n --argjson rect "$rect" '$rect .width')
sh=$(jq -n --argjson rect "$rect" '$rect .height')

printf "%s\n" "$message" \
| dzen2 -p 1 -bg "$bg" -fg "$fg" -fn "$font" \
    -w $mw \
    -h $mh \
    -x $((sx+(sw-mw)/2)) \
    -y $((sy+(sh-mh)/2))

