#!/bin/sh

if [ "$1" == "--help" -o "$1" == "" ]; then
    echo "Usage: $0 <time in minutes>"
    exit 1
fi

# font
font="Terminess Nerd Font Mono:size=16:style=medium"

# background
bg="#432d59"

# foreground
fg="#00ff00"

# time output format
format="%H:%M:%S"

# current OS
uname=$(uname)

# message
message="Time is up!"

get_time() {
    if test "$uname" = "FreeBSD"; then
        date -u -j -f "%s" $1 +"$format"
    else
        date -u --date="@$1" +"$format"
    fi
}

mh=32
mw1=$(xftwidth "$font" $(get_time 0))
mw2=$(xftwidth "$font" "$message")
mx=0
my=0

# path to alarm sound
alarm="$HOME/Alarms/Industrial alarm.mp3"

# convert time to seconds
period=$1
period=$(( period * 60 ))

# get current timestamp
timestamp=`date +%s`
timefinish=$(( timestamp + period ))

prev_time=0
while true; do
    time=$(( timefinish - timestamp ))

    # redraw screen only if time changed
    if test $prev_time -ne $time; then
        prev_time=$time
        get_time $time
    fi

    if test $timestamp -ge $timefinish; then
        break
    fi

    sleep 0.1
    timestamp=`date +%s`
done | dzen2 -bg "$bg" -fg "$fg" -fn "$font" -w $mw1 -h $mh -x $mx -y $my

echo "$message" | dzen2 -p 5 -bg "$bg" -fg "$fg" -fn "$font" -w $mw2 -h $mh -x $mx -y $my &

if which "notify-send"; then
    notify-send "$message"
fi

if test -f "$alarm"; then
    mpv "$alarm"
fi
