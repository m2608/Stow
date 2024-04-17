#!/bin/sh

self=$(basename "$0")

# for example, "PragmataPro Liga:size=13"
current_spec=$(xrdb -query | sed -n '/^st[.]font:/p' | sed -r 's/^st.font:[\s\t]*//')
current_font=$(echo "$current_spec" | cut -d ':' -f 1)
current_size=$(echo "$current_spec" | cut -d ':' -f 2 | cut -d '=' -f 2)

while test $# -gt 0; do
    case "$1" in
        -f|--font)
            font="$2"
            shift
            shift
            ;;
        -s|--size)
            size="$2"
            shift
            shift
            ;;
        *)
            echo "Usage: $self [--font font] [--size +1|-1|size]"
            exit 1
            ;;
    esac
done

if test -z "$font" -a -z "$size"; then
    echo "Current font spec: \"$current_spec\""
    exit 0
fi

if test -z "$font" -a -z "$current_font"; then
    echo "Could not change font size, because it's name is not set in Xresources database."
    exit 1
fi

if test -z "$size" -a -z "$current_size"; then
    echo "Could not change font name, because it's size is not set in Xresources database."
    exit 1
fi

if test "$size" = "+1" -o "$size" = "-1"; then
    if test -n "$current_size"; then
        size=`echo "$current_size $size"| bc`
    else
        echo "Could not change font size, because it is not set in Xresources database."
        exit 1
    fi
fi

if test -z "$font"; then
    font="$current_font"
fi

if test -z "$size"; then
    size="$current_size"
fi

spec="$font:size=$size"

# write new font spec to temporary file
tmpfile=`mktemp /tmp/$self.XXXXXX` || exit 1
echo "st.font: $spec" > "$tmpfile"

# merge changes to Xresources DB
xrdb -merge "$tmpfile"

# send USR1 signal to change font
if test $(uname) = "FreeBSD"; then
    # In FreeBSD you should pass "-a" key to ps to include
    # current process ancestors.
    pkill -USR1 -xa st
else
    # Linux ps does not have "-a" key, but it includes current
    # process ancestors by default.
    pkill -USR1 -x st
fi

echo "Font set: \"$spec\""
