#!/bin/sh

OS=$(uname -o)

battery_status()
{
    icons="󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹"

    case "$OS" in
        "FreeBSD")
            batt=`sysctl hw.acpi.battery.life  | cut -d ':' -f 2 | tr -d ' '`
            stat=`sysctl hw.acpi.battery.state | cut -d ':' -f 2 | tr -d ' '`
            if test $stat -eq 2; then
                stat="Charging"
            fi
            ;;
        "Linux")
            batt=`cat /sys/class/power_supply/BAT0/capacity`
            stat=`cat /sys/class/power_supply/BAT0/status`
            ;;
    esac

    numb=$((batt/10))
    icon=$(echo "$icons" | cut -b $((numb*4+1))-$((numb*4+4)))

    if test "$stat" = "Charging"; then
        icon="${icon}󱐋"
    fi

    echo "$icon $batt%"
}

volume_status()
{
    icon="󰕿"

    volume=`sndioctl | sed '/^output.level=/!d;s/^output.level=//'`
    volume=`echo "($volume*100)/1" | bc`

    echo "$icon $volume"
}

temperature()
{
    case "$OS" in 
        "FreeBSD")
            temp=`sysctl hw.acpi.thermal.tz0.temperature \
                | cut -d ':' -f 2 | tr -d ' ' | cut -d '.' -f 1`
            ;;

        "Linux")
            temp=$(cat /sys/devices/platform/coretemp.0/hwmon/*/temp1_input | head -n 1)
            temp=$((temp/1000))
            ;;
    esac

    echo "$temp"
}

update_status()
{
    time=`date +"%d.%m %H:%M"`

    lang=`xkb-switch | tr 'a-z' 'A-Z'`

    batt=$(battery_status)
    temp=$(temperature)
    volume=$(volume_status)

    xsetroot -name " $temp°C $batt $volume♪ $lang $time"
}

my_pid=$$
if [ "$1" = "loop" ]; then
    script_name=`basename $0`
    all_pids=`pgrep "$script_name"`
    other_pids=`echo "$all_pids" | grep -v $my_pid`
    if test -n "$other_pids"; then
        for pid in "$other_pids"; do
            kill $pid
        done
    fi
    while [ 1 ]; do
        update_status
        sleep 2
    done
else
    update_status
fi
