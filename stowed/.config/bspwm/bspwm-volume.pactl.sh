#!/bin/sh

test -n "$1" || exit 0

action="$1"

sink=$(pactl list short sinks                 \
    | grep RUNNING                            \
    | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
    | head -n 1)

if test -z "$sink"; then
	$(dirname $0)/bspwm-message.sh "NO SOUND"
	exit 0
fi

if test "$action" = "up" ; then

    # увеличить громкость
    pactl set-sink-mute $sink 0
    pactl set-sink-volume $sink +5%

elif test "$action" = "down"; then

    # уменьшить громкость
    pactl set-sink-mute $sink 0
    pactl set-sink-volume $sink -5%

elif test "$action" = "mute"; then

    # замьютить
    mute_state=$(pactl get-sink-mute $sink \
        | head -n 1                        \
        | cut -d ' ' -f 2                  \
        | sed 's/yes/0/;s/no/1/')

    pactl set-sink-mute $sink $mute_state
fi

pactl_version=$(pactl --version \
    | sed -En '/^pactl[ ]+/p' \
    | sed -E 's/^pactl[ ]+([0-9]+)([.].*)?/\1/')

if test $pactl_version -ge 15; then
    if test $(pactl get-sink-mute $sink | cut -d ':' -f 2 | tr -d ' ') = "yes"; then
        message="Volume: mute"
    else
        volume=$(pactl get-sink-volume $sink \
            | head -n 1 | cut -d '/' -f 2 | tr -d ' ')
        message="Volume: $volume"
    fi
else
    mute=$(LANG=C pactl list sinks     \
        | sed -n "/^Sink #$sink$/,/^$/p" \
        | sed -nE '/^[\s\t]+Mute:/p'   \
        | sed -E 's/^[\s\t]+Mute:[ ]+//')

    if test "$mute" = "yes"; then
        message="Volume: mute"
    else
        volume=$(LANG=C pactl list sinks     \
            | sed -n "/^Sink #$sink$/,/^$/p" \
            | sed -nE '/^[\s\t]+Volume:/p'   \
            | sed -E 's/^.*[ ]([0-9]+)%.*[ ]([0-9]+)%.*/\1/')
        message="Volume: $volume"
    fi
fi

$(dirname $0)/bspwm-message.sh "$message"
