#!/bin/sh

hostname=$({ hostname || hostnamectl hostname; } | cut -d "." -f 1)
current_dir=$(dirname $0)

pkill -x polybar
sleep 0.5
exec polybar -c "$current_dir/config#$hostname.ini"
