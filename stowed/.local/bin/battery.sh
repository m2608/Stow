#!/bin/sh

icons="󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"

case "$(uname)" in
    "FreeBSD")
        batt=`sysctl hw.acpi.battery.life  | cut -d ':' -f 2 | tr -d ' '`
        stat=`sysctl hw.acpi.battery.state | cut -d ':' -f 2 | tr -d ' '`
        if test $stat -eq 2; then stat="Charging"; fi
        ;;
    "Linux")
	path=$(find -L "/sys/class/power_supply" -mindepth 2 -maxdepth 2 -name "capacity" -exec dirname {} \; 2> /dev/null)
	batt=$(cat "$path/capacity")
	stat=$(cat "$path/status")
        ;;
esac

if test "$stat" = "Charging"; then
    icon="󱐋"
else
    numb=$((batt/10))
    icon=$(echo "$icons" | cut -b $((numb*4+1))-$((numb*4+4)))
fi

echo "$icon $batt%"
