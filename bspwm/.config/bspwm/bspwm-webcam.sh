#!/bin/sh

TITLE=webcam

window_id=$(xdotool search -name "$TITLE" | head -n 1)

if test -n "$window_id"; then
    bspc node "$window_id" --flag hidden
    exit 0
fi

# screen width
sw=$(xwininfo -root | grep Width  | cut -d ':' -f 2)
sh=$(xwininfo -root | grep Height | cut -d ':' -f 2)

# webcam width
w=320
h=240

# gaps
gapx=6
gapy=6

x=$((sw-w-gapx))
y=$((sh-h-gapy))

bspc rule -a 'ffplay' -o            \
    state=floating                  \
    sticky=on                       \
    center=off                      \
    layer=above                     \
    rectangle="${w}x${h}+${x}+${y}" \
&& exec ffplay                      \
    -f v4l2                         \
    -window_title "$TITLE"          \
    -video_size "${w}x${h}"         \
    -framerate 25                   \
    -i /dev/video0                  \
    -fflags nobuffer
