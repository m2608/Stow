#!/bin/sh

test -n "$1" || exit 0

action="$1"

dev="vol"

if   test "$action" = "mute" ; then
    mixer $dev.mute=^     >/dev/null
elif test "$action" = "up"   ; then
    mixer $dev.volume=+5% >/dev/null
elif test "$action" = "down" ; then
    mixer $dev.volume=-5% >/dev/null
fi

mute_state=$(mixer $dev.mute | cut -d '=' -f 2)

if test "$mute_state" = "1"; then
    message="Volume: mute"
else
    volume=$(
        mixer vol.volume  \
        | cut -d ':' -f 2 \
        | xargs -I{} bc -l -e "r({}*100, 0)"
    )
    message="Volume: $volume%"
fi

$(dirname $0)/bspwm-message.sh "$message"

