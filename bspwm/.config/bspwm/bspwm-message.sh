#!/bin/sh

test -n "$1" || exit 0

get_resource() {
    name="$1"
    xrdb -query | sed -r -n "/^$name:/ s/$name:[\\s\\t]+// p"
}

message="$1"

font=$(get_resource "bspwm-message[.]font")
bg=$(get_resource "bspwm-message[.]background")
fg=$(get_resource "bspwm-message[.]foreground")

: "${font:='Terminus:size=16'}"
: "${bg:='#432d59'}"
: "${fg:='#00ff00'}"


# message size
mw=$(xftwidth "$font" "$message")
mh=32

# screen size
wininfo=$(xwininfo -root)
sw=$(echo "$wininfo" | grep Width  | cut -d ':' -f 2)
sh=$(echo "$wininfo" | grep Height | cut -d ':' -f 2)

echo "$message" \
| dzen2 -p 1 -bg "$bg" -fg "$fg" -fn "$font" \
    -w $mw            \
    -h $mh            \
    -x $(((sw-mw)/2)) \
    -y $(((sh-mh)/2))

