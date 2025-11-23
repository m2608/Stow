#!/bin/sh
# Подключает зашифрованный диск с помощью GEOM ELI и импортирует с него указанный ZFS пул.

self=`basename "$0"`

if test -z $2; then
    echo "Usage: $self <disk> <pool>"
    exit 1
fi

disk=$1
pool=$2

# Проверяем, что диск, которое мы хотим подключить существует.
echo "$self: Looking for device $disk..."
if test -c "/dev/$disk"; then
    echo "$self: Special character device $disk found."

    # Проверяем, не подключено ли уже устройство.
    geli list "$disk.eli" 2> /dev/null > /dev/null
    if test $? -eq 0; then
        echo "$self: Device $disk already attached to geli."
        # Раз устройство подключено, проверяем, не импортирован ли уже пул. 
        zpool list $pool 2> /dev/null > /dev/null
        if test $? -eq 0; then
            # Пул импортирован, больше ничего делать не надо. Просто выходим из скрипта без ошибки.
            echo "$self: Pool $pool already imported from attached device $disk"
            exit 0
        fi
    else
        # Подключаем диск.
        echo "$self: Attaching device $disk..."
        geli attach $disk
        if test $? -ne 0; then
            echo "$self: Could not attach device $disk."
            exit 1
        fi
    fi

    # Проверяем, не импортирован ли пул. Если он импортирован, вероятно, устройство было отключено
    # Без экспортирования пула - и он работать не будет, надо его переимпортировать.
    zpool list $pool 2> /dev/null > /dev/null 
    if test $? -eq 0; then
        echo "$self: Pool $pool already imported, but disk $disk was not attached. Exporting pool $pool..."
        # Экспортируем пул.
        zpool export $pool
        if test $? -ne 0; then
            echo "$self: Could not export pool $pool."
            exit 1
        fi
    fi

    # Импортируем пул.
    echo "$self: Importing pool $pool..."
    zpool import $pool
    if test $? -eq 0; then
        echo "$self: Success."
    else
        echo "$self: Could not import pool $pool."
        exit 1
    fi
else
    echo "$self: Special character device $disk does not exist."
    exit 1
fi
