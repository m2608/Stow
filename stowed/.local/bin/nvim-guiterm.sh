#!/bin/sh

command="nvim"

while test $# -gt 0; do
    command="${command} \"$1\""
    shift
done

st -e fish -i -c "$command"
