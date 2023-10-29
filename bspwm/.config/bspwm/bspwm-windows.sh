#!/bin/sh

winids=$(bspc query -N -n .window)

titles=$(echo "$winids" | xargs xtitle)


