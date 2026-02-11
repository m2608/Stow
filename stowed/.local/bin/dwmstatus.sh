#!/bin/sh

OS=$(uname)

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
            path=`find "/sys/class/power_supply" -name 'BAT*'`
            batt=`cat "$path/capacity"`
            stat=`cat "$path/status"`
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
    volume=""

    if command -v sndioctl > /dev/null; then
        volume=`sndioctl | sed '/^output.level=/!d;s/^output.level=//'`
        volume=`echo "($volume*100)/1" | bc`
    elif command -v wpctl > /dev/null; then
        volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d ' ' -f 2)
        int_part=`echo "$volume" | cut -d '.' -f 1`
        frc_part=`echo "$volume" | cut -d '.' -f 2`
        volume=$((int_part*100 + frc_part))
    fi

    test -n "$volume" && echo "$icon $volume♪"
}

temperature()
{
    icon=""
    temp=""
    case "$OS" in 
        "FreeBSD")
            temp=`sysctl hw.acpi.thermal.tz0.temperature \
                | cut -d ':' -f 2 | tr -d ' ' | cut -d '.' -f 1`
            ;;

        "Linux")
            path="/sys/devices/platform/coretemp.0"
            if test -d "$path"; then
                temp=$(cat "$path"/hwmon/*/temp1_input | head -n 1)
                temp=$((temp/1000))
            fi
            ;;
    esac

    test -n "$temp" && echo "$icon $temp°C"
}

update_status()
{
    time=$(date +"%d.%m %H:%M")

    command -v xkb-switch > /dev/null && lang=$(xkb-switch | tr 'a-z' 'A-Z')

    batt=$(battery_status)
    temp=$(temperature)
    volume=$(volume_status)

    status=$(echo "${temp} ${batt} ${volume} ${lang} ${time}" | sed -r 's/[ ]+/ /g' | sed -r 's/^[ ]*//')

    if command -v xsetroot > /dev/null; then
        xsetroot -name "$status"
    elif command -v dwmstatus-set > /dev/null; then
        dwmstatus-set "$status"
    fi
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
