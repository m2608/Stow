#!/bin/sh

HDMIDSP=/dev/dsp1.0

if test -c $HDMIDSP; then
    AUDIODEV=$HDMIDSP /usr/local/bin/play -q -n synth brownnoise vol 0.0001
fi

