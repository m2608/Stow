#!/bin/sh

hostname=$(hostnamectl hostname || hostname | cut -d '.' -f 1)

if test "$hostname" = "steamdeck"; then
    if xrandr --listmonitors | grep -q eDP; then
        xrandr --output eDP --off
        xrandr --output DisplayPort-0 --auto
    else
        xrandr --output DisplayPort-0 --off
        xrandr --output eDP --auto --rotate right
    fi
fi
