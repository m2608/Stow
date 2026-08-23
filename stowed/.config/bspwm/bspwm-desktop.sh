#!/bin/sh

test -n "$1" && test -n "$2" || exit 0

# действие: focus, send
action="$1"

test "$action" = "focus" -o "$action" = "send" || exit 0

# номер рабочего стола, на который переключаемся
destination="$2"

if test "$action" = "focus"; then

    bspc desktop -f "$destination"
    $(dirname $0)/bspwm-message.sh "Workspace: $destination_n"

elif test "$action" = "send"; then
    bspc node -d "$destination"
fi
