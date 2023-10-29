#!/bin/sh

test -n "$1" || exit 0

action="$1"

if test "$action" = "up"; then

    # увеличить громкость
    pactl set-sink-volume $( \
        pactl list short sinks \
            | grep RUNNING \
            | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
            | head -n 1
    ) +5%

elif test "$action" = "down"; then

    # уменьшить громкость
    pactl set-sink-volume $( \
        pactl list short sinks \
            | grep RUNNING \
            | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
            | head -n 1 \
    ) -5%

elif test "$action" = "mute"; then

    # замьютить
    pactl set-sink-mute $( \
        pactl list short sinks \
            | grep RUNNING \
            | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
            | head -n 1 \
    ) $( \
        LC_ALL=C pactl list sinks \
            | grep Mute \
            | head -n 1 \
            | cut -d ' ' -f 2 \
            | sed 's/yes/0/;s/no/1/' \
    )
fi
