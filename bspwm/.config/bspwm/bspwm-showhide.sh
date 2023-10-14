#!/bin/sh

test -n "$1" || exit 0

class="$1"

bspc node $( \
    bspc query -N \
    | xargs -I{} bspc query -T -n {} \
    | jq "select(.client.className == \"$class\") | .id" \
) --flag hidden
