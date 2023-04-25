#!/bin/sh

# Выбираем скрипт в зависимости от имени машины.
script="$(realpath $(dirname $0))/$(basename $0)#$(hostname | cut -d '.' -f 1)"

if test -f "$script"; then
    exec "$script"
fi
