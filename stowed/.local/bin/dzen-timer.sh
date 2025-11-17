#!/bin/sh

if [ "$1" == "--help" -o "$1" == "" ]; then
    echo "Usage: $0 <time in minutes>"
    exit 1
fi

# check for required tools
command -v dzen2 > /dev/null || exit 1
magick=$(command -v magick || command -v convert) || exit 1

get_resource() {
    name="$1"
    xrdb -query | sed -r -n "/^$name:/ s/$name:[\\s\\t]+// p"
}

get_time() {
    format="%H:%M:%S"

    if test "$(uname)" = "FreeBSD"; then
        date -u -j -f "%s" $1 +"$format"
    else
        date -u --date="@$1" +"$format"
    fi
}

# get settings from resources
font=$(get_resource "bspwm-message[.]font")
bg=$(get_resource "bspwm-message[.]background")
fg=$(get_resource "bspwm-message[.]foreground")

# default settings
: "${font:='Terminus:size=16'}"
: "${bg:='#432d59'}"
: "${fg:='#00ff00'}"

# get font file and size for magick
fontfile=$(fc-match -f "%{file}" "$font")
fontsize=$(fc-match -f "%{size}" "$font")

# message
message="Time is up!"

# get screen dpi
dpi=$(xdpyinfo | sed -n -r '/^[ ]*resolution:[ ]+[0-9]+x[0-9]+ dots/ s/^[ ]*resolution:[ ]+([0-9]+)x([0-9]+) dots .*/(\1+\2)\/2/p' | bc)

# time message size
size=$("$magick" -density $dpi -font "$fontfile" -pointsize $fontsize label:$(get_time 0) -format "%wx%h" info:)

mw1=$(echo $size | cut -d 'x' -f 1)
mh1=$(echo $size | cut -d 'x' -f 2)

# timeout message size
size=$("$magick" -density $dpi -font "$fontfile" -pointsize $fontsize label:"Time is up!" -format "%wx%h" info:)

mw2=$(echo $size | cut -d 'x' -f 1)
mh2=$(echo $size | cut -d 'x' -f 2)

# position
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
done | dzen2 -bg "$bg" -fg "$fg" -fn "$font" -w $mw1 -h $mh1 -x $mx -y $my

echo "$message" | dzen2 -p 5 -bg "$bg" -fg "$fg" -fn "$font" -w $mw2 -h $mh2 -x $mx -y $my &

if which -s "notify-send"; then
    notify-send "$message"
fi

if test -f "$alarm"; then
    mpv --terminal=no "$alarm"
fi
