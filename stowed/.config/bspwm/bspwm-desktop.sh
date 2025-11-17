#!/bin/sh

test -n "$1" && test -n "$2" && test -n "$3" || exit 0

# действие: focus, send
action="$1"

test "$action" = "focus" -o "$action" = "send" || exit 0

# номер рабочего стола, на который переключаемся
target_n="$2"

# общее количество рабочих столов на одном мониторе
total_n="$3"

# номер текущего монитора
mon_n=$(bspc query -M | sed -n "/$(bspc query -M -m focused)/{=;q;}")

# номер десктопа в терминах bspwm
desktop_n=$(((mon_n-1)*total_n+target_n))

if test "$action" = "focus"; then

    bspc desktop -f "$desktop_n"

    $(dirname $0)/bspwm-message.sh "Workspace: $(bspc query -D -d focused --names)"

elif test "$action" = "send"; then
    bspc node -d "$desktop_n"
fi
