#!/bin/sh

# Default values
w=1712
h=1430
f=60
display="Virtual-1"

self=`basename "$0"`
help="Usage: $self [-w|--width <screen width>] [-h|--height <screen height>] [-f|--freq <refresh rate>] [-d|--display <display name>]"

while test $# -gt 0; do
    case "$1" in
        -w|--width)
            w="$2"
            shift
            shift
            ;;
        -h|--height)
            h="$2"
            shift
            shift
            ;;
        -f|--freq)
            f="$2"
            shift
            shift
            ;;
        -d|--display)
            display="$2"
            shift
            shift
            ;;
        --help)
            echo "$help"
            exit 1
            ;;
    esac
done

echo $w $h $f $display
exit 0


modeline=$(cvt $w $h $f | grep Modeline | cut -d ' ' -f 2-)
modename=$(echo "$modeline" | cut -d ' ' -f 1)

xrandr --newmode $modeline
xrandr --addmode "$display" "$modename"
xrandr --output "$display" --mode "$modename"
