#!/bin/sh

test $(id -u) -eq 0 || { printf "Should be run as root.\n"; exit 1; }

pkg=""
folder=$(dirname "$0")
os=$(cat /etc/os-release | sed -n -r 's/^NAME="(.*)"/\1/p')

packages="curl gcc git"
make="make"
build_janet=0
build_jpm=0

case $os in
    FreeBSD)
        packages="$packages gmake janet jpm"
        pkg_update="pkg update"
        pkg_install="pkg install -y"
        make="gmake"
        ;;
    Void*)
        packages="$packages make janet jpm"
        pkg_update="xbps-install -S"
        pkg_install="xbps-install -y"
        ;;
    Alpine*)
        packages="$packages make build-base janet janet-dev"
        pkg_update="apk update"
        pkg_install="apk add"
        build_jpm=1
        ;;
    Debian*)
        packages="$packages make"
        pkg_update="apt update"
        pkg_install="apt install -y"
        build_janet=1
        build_jpm=1
        ;;
esac

test -n "$pkg_install" || { printf "Unknown OS: %s\n" "$os"; exit 1; }

$pkg_install $packages

if test $build_janet -ne 0; then
    "$make" -f "$folder/makefiles/janet.mk" PREFIX=/usr
fi

if test $build_jpm -ne 0;   then
    "$make" -f "$folder/makefiles/jpm.mk"   PREFIX=/usr
fi

jpm install spork
