#!/bin/sh

# window title
title="layout"
# screen width
# sw=$(xwininfo -root | grep Width | cut -d ':' -f 2)
# width of the leftmost monitor
sw=$(bspc query -M \
    | parallel -k -n 1 bspc query -T -m {} \
    | jq --slurp 'sort_by(.rectangle | .x) | .[0] .rectangle .width')
# icon width
iw=28
# font
font="Terminess Nerd Font Mono:size=16"
# background
bg="#432d59"
# foreground
fg="#00ff00"

set -m

while true; do 
    xkb-switch -p | tr a-z A-Z
    xkb-switch --wait
done | dzen2 \
    -e "button1=exec:xkb-switch -n" \
    -title-name "$title" \
    -p 0 -bg "$bg" -fg "$fg" -fn "$font" -x $((sw-iw)) -w $iw -h $iw
