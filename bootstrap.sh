#!/bin/sh

pkg=""
folder=$(dirname "$0")
os=$(cat /etc/os-release | sed -n -r 's/^NAME=//p')

packages="curl gcc git"
make="make"

case $os in
    FreeBSD)
        packages="$packages gmake"
        pkg="pkg install"
        make="gmake"
        ;;
    Debian*)
        packages="$packages make"
        pkg="apt install"
        ;;
    Void*)
        packages="$packages make"
        pkg="xbps-install"
        ;;
esac

test -n "$pkg" || { printf "Unknown os: %s\n" "$os"; exit 1; }

$pkg $packages

"$make" -f "$folder/makefiles/janet.mk"
"$make" -f "$folder/makefiles/jpm.mk"
