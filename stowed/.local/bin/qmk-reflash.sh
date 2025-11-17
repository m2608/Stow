#!/bin/sh

if test -z "$1" -o -z "$2"; then
    echo 'QMK reflash script. Usage: '`basename $0`' <port> <firmware>'
    exit 1
fi

port="$1"
file="$2"

chars=". .. ..."
i=1

while true; do
    printf "\rWaiting for port %s, reset the keyboard please%-3s" "$port" `echo -n $chars | cut -d ' ' -f $i`
    i=$((i%3+1))
    if test -c "$port"; then
        avrdude -p m32u4 -c avr109 -P "$port" -U flash:w:"$file"
        sleep 1
        echo "Resetting the keyboard after flashing..."
        stty -f "$port" 1200
        break
    fi
    sleep 1
done
