#!/bin/sh

test $(id -u) -eq 0 || { printf "Should be run as root.\n"; exit 1; }

pkg=""
folder=$(dirname "$0")
os=$(cat /etc/os-release | sed -n -r 's/^NAME="(.*)"/\1/p')

packages="curl gcc git stow"
make="make"

case $os in
    FreeBSD)
        packages="$packages gmake chez-scheme"
        pkg_update="pkg update"
        pkg_install="pkg install -y"
        make="gmake"
        ;;
    Void*)
        packages="$packages make chez-scheme"
        pkg_update="xbps-install -S"
        pkg_install="xbps-install -y"
        ;;
    Alpine*)
        packages="$packages make build-base chez-scheme"
        pkg_update="apk update"
        pkg_install="apk add"
        ;;
    Debian*)
        packages="$packages make"
        pkg_update="apt update"
        pkg_install="apt install -y"
        ;;
esac

test -n "$pkg_install" || { printf "Unknown OS: %s\n" "$os"; exit 1; }

$pkg_install $packages

