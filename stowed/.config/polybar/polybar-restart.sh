#!/bin/sh

hostname=$({ hostname || hostnamectl hostname; } | cut -d "." -f 1)
current_dir=$(dirname $0)

if pkill -x polybar; then
    sleep 0.5
fi
exec polybar -c "$current_dir/config#$hostname.ini"
