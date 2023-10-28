#!/bin/sh

test -n "$1" && test -n "$2" || exit 0

# номер рабочего стола, на который переключаемся
target_n="$1"

# общее количество рабочих столов на одном мониторе
total_n="$2"

# номер текущего монитора
mon_n=$(bspc query -M | sed -n "/$(bspc query -M -m focused)/{=;q}")

# номер десктопа в терминах bspwm
desktop_n=$(((mon_n-1)*total_n+target_n))

font="*-terminus-*-*-*-*-32-*"

width=$(echo "$message" | dzen2-textwidth "$font" "$message")

bspc desktop -f "$desktop_n" && \
    echo "Workspace: $(bspc query -D -d focused --names)" \
    | osd_cat -d 1 -w --pos middle --align center -c green --outline 2 -f "$font" -