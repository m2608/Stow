#!/bin/sh

# window title
title="layout"
# screen width
sw=$(xwininfo -root | grep Width | cut -d ':' -f 2)
# icon width
iw=28
# font
font="Terminus:size=16:style=medium"
# background
bg="#432d59"
# foreground
fg="#00ff00"

set -m

sh -c '
    xkb-switch | tr a-z A-Z
    while true; do 
        xkb-switch --wait -p | tr a-z A-Z
    done' | dzen2 \
        -e "button1=exec:xkb-switch -n" \
        -title-name "$title" \
        -p 0 -bg "$bg" -fg "$fg" -fn "$font" -x $((sw-iw)) -w $iw -h $iw
