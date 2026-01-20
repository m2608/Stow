#!/bin/sh

test -n "$1" || exit 0

action="$1"

dev="vol"

if   test "$action" = "mute" ; then
    wpctl set-mute @DEFAULT_SINK@ toggle
elif test "$action" = "up"   ; then
    wpctl set-mute   @DEFAULT_SINK@ 0   > /dev/null
    wpctl set-volume @DEFAULT_SINK@ 5%+ > /dev/null
elif test "$action" = "down" ; then
    wpctl set-mute   @DEFAULT_SINK@ 0   > /dev/null
    wpctl set-volume @DEFAULT_SINK@ 5%- > /dev/null
fi

if wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; then
    message="Volume: mute"
else
    volume=$(wpctl get-volume @DEFAULT_SINK@ | cut -d ' ' -f 2)
    int_part=`echo "$volume" | cut -d '.' -f 1`
    frc_part=`echo "$volume" | cut -d '.' -f 2`
    volume=$((int_part*100 + frc_part))

    message="Volume: $volume%"
fi

$(dirname $0)/bspwm-message.sh "$message"

