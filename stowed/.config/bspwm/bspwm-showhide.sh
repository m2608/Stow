#!/bin/sh

test -n "$1" || exit 0

class="$1"

bspc query -N                                        \
| xargs -I{} bspc query -T -n {}                     \
| jq "select(.client.className == \"$class\") | .id" \
| xargs -I{} bspc node {} --flag hidden
