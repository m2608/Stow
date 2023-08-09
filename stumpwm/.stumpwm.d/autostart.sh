#!/bin/sh

xsetroot -solid black
xsetroot -cursor_name left_ptr

# добавляем каталоги шрифтов
find /usr/local/share/fonts -type d -mindepth 1 -maxdepth 1 -exec xset fp+ {} \;
xset fp+ $HOME/.fonts
xset fp rehash

# отключаем хранитель экрана
xset -dpms
xset s off

# Вывод звука по умолчанию через HDMI.
sysctl hw.snd.default_unit=1

xrdb -merge ~/.Xresources

setxkbmap -layout us,ru -option "grp:caps_toggle" -option "compose:menu"
