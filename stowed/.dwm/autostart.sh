#!/bin/sh

if command -v hostname > /dev/null; then
    hostname=$(hostname)
elif command -v hostnamectl > /dev/null; then
    hostname=$(hostnamectl hostname)
fi

hostname=$(echo "$hostname" | cut -d '.' -f 1)

# Выбираем скрипт в зависимости от имени машины.
if test -n "$hostname"; then
    script="$(realpath $(dirname $0))/$(basename $0)#$hostname"

    if test -f "$script"; then
        exec "$script"
    fi
fi
