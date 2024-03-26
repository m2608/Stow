#!/bin/sh

test -n "$1" || exit 0
direction="$1"

bspc desktop -f "$direction.local"
$(dirname $0)/bspwm-message.sh "Workspace: $(bspc query -D -d focused --names)"
