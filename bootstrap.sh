#!/bin/sh

test $(id -u) -eq 0 || { printf "Should be run as root.\n"; exit 1; }

pkg=""
folder=$(dirname "$0")
os=$(cat /etc/os-release | sed -n -r 's/^NAME="(.*)"/\1/p')

packages="curl gcc git"
make="make"
build_janet=0

case $os in
    FreeBSD)
        packages="$packages gmake janet jpm"
        pkg="pkg install"
        make="gmake"
        ;;
    Debian*)
        packages="$packages make"
        pkg="apt install"
        build_janet=1
        ;;
    Void*)
        packages="$packages make janet jpm"
        pkg="xbps-install"
        ;;
esac

test -n "$pkg" || { printf "Unknown OS: %s\n" "$os"; exit 1; }

$pkg $packages

if test $build_janet -ne 0; then
    "$make" -f "$folder/makefiles/janet.mk" PREFIX=/usr/local
    "$make" -f "$folder/makefiles/jpm.mk"   PREFIX=/usr/local
fi
