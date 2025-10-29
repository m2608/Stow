#!/bin/sh

# max buffer size
min_size=800000
max_size=1000000

# number of colors
colors=192
self=`basename "$0"`
help='Usage: '$self' <options> <file>

Options:

-v --verbose                   make output verbose, default: no
-c --colors <number of colors> set number of colors in palette, default: '$colors'
--min <min file size>          minimum file size, default: '$min_size' bytes
--max <max file size>          maximum file size, default: '$max_size' bytes
-x --clear-screen              clear screen to show image, default: no
'

while test $# -gt 0; do
    case "$1" in
        --min)
            min_size="$2"
            shift
            shift
            ;;
        --max)
            max_size="$2"
            shift
            shift
            ;;
        -c|--colors)
            colors="$2"
            shift
            shift
            ;;
        -x|--clear-screen)
            clear="yes"
            shift
            ;;
        -v|--verbose)
            verbose="yes"
            shift
            ;;
        -h|--help)
            echo "$help"
            exit 0
            ;;
        *)
            file="$1"
            shift
            break
            ;;
    esac
done

if test -z "$file"; then
    printf "Filename is required\n"
    exit 1
fi

if ! test -f "$file"; then
    printf "File not found: %s\n" "$file"
    exit 1
fi

is_number() {
    case $1 in
        *[!0-9]*)
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}

if ! is_number "$min_size"; then
    printf "Minimal file size should be a number\n"
    exit 1
fi

if ! is_number "$max_size"; then
    printf "Maximal file size should be a number\n"
    exit 1
fi

if ! is_number "$colors"; then
    printf "Number of colors should be a number\n"
    exit 1
fi

if test $min_size -gt $max_size; then
    temp=$min_size
    min_size=$max_size
    max_size=$temp
fi

# Parse value from `xwininfo` output.
get_value() {
    printf "%s" "$1" | sed -n "/^[ ]*$2:[ ]*/p" | sed "s/^[ ]*$2:[ ]*//"
}

# Parse terminal size from `xwininfo output`.
get_term_size() {
    printf "%s" "$1" \
        | sed -n '/^[ ]*-geometry[ ]*/p' \
        | sed -r 's/[ ]*-geometry[ ]*([0-9]+)x([0-9]+).*/\1 \2/'
}

# Get image resolution.
get_image_size() {
    identify -format "%w %h" "$1"
}

wininfo=$(xwininfo -id $(xdotool getactivewindow))

# terminal window graphic size (in pixels)
term_gw=$(get_value "$wininfo" "Width")
term_gh=$(get_value "$wininfo" "Height")

# terinal window text size (in chars) 
size=$(get_term_size "$wininfo")

term_tw=$(printf "%s" "$size" | cut -d ' ' -f 1)
term_th=$(printf "%s" "$size" | cut -d ' ' -f 2)

# size of char in terminal (in pixels)
char_gw=$((term_gw / term_tw))
char_gh=$((term_gh / term_th))

# pane size (in chars)
pane_tw=$(tput cols)
pane_th=$(tput lines)

# pane size (in pixels)
pane_gw=$((pane_tw * char_gw))
pane_gh=$((pane_th * char_gh))

size=$(get_image_size "$file")

image_gw=$(printf "%s" "$size" | cut -d ' ' -f 1)
image_gh=$(printf "%s" "$size" | cut -d ' ' -f 2)


if test $pane_gw -lt $image_gw -o $pane_gh -lt $image_gh; then
    w=$pane_gw
    h=$pane_gh
else
    w=$image_gw
    h=$image_gh
fi

last_w=$w
last_h=$h

last_size=0

iter=0

if test -n "$verbose"; then
    printf "Image resolution: %dx%d\n" $image_gw $image_gh
    printf "Pane resolution: %dx%d\n" $pane_gw $pane_gh
    printf "Target file size: %d-%d bytes\n" $min_size $max_size
fi

temp=$(mktemp)

if test $(uname) = "FreeBSD"; then
    format="-f %z"
else
    format="-c %s"
fi

while true; do

    magick "$file" -colors $colors -resize "${w}x${h}"\> sixel:- > "$temp"
    size=$(stat $format "$temp")

    if test -n "$verbose"; then
        printf "Iteration %d, image resolution: %dx%d, %d bytes\n" $iter $w $h $size 1>&2
    fi

    if test $iter -eq 0 -a $size -le $max_size; then
        break
    fi

    if test $size -ge $min_size -a $size -le $max_size; then
        break
    fi

    if test $size -eq $last_size; then
        break
    fi

    if test $size -gt $max_size; then
        last_w=$w
        last_h=$h

        w=$((w / 2))
        h=$((h / 2))
    else
        w=$(((last_w + w) / 2))
        h=$(((last_h + h) / 2))
    fi

    last_size=$size
    iter=$((iter + 1))
done

if test -n "$clear"; then
    printf "\033[2J\033[H"
fi

cat "$temp"
rm "$temp"
