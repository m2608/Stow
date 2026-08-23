#!/bin/sh

hostname=$(hostnamectl hostname || hostname | cut -d '.' -f 1)

# Функция переключает мониторы и переносит все окна со старого монитора,
# сохраняя при этом рабочие столы.
swap_monitors() {
    src_mon="$1"
    dst_mon="$2"

    # Создаём рабочие столы на втором мониторе.
    bspc monitor "$dst_mon" -d 6 7 8 9 10

    # Выполняем для каждого рабочего стола.
    for s in 1 2 3 4 5; do
        d=$((s+5))
        # Переносим ноды на новый монитор.
        bspc query -N -d "$s" | xargs -I {} bspc node "{}" -d "$d"
        # Удаляем старый рабочий стол.
        bspc desktop "$s" -r
        # Переименовываем новый рабочий стол.
        bspc desktop "$d" -n "$s"
    done
    bspc monitor "$src_mon" -r
}

if test "$hostname" = "steamdeck"; then
    if xrandr --listmonitors | grep -q eDP; then

        src_mon="eDP"
        dst_mon="DisplayPort-0"

        xrandr \
            --output "$dst_mon" --auto --primary \
            --output "$src_mon" --off

        swap_monitors "$src_mon" "$dst_mon"
    else
        src_mon="DisplayPort-0"
        dst_mon="eDP"

        xrandr \
            --output "$src_mon" --off \
            --output "$dst_mon" --mode 800x1280 --rotate right --primary

        swap_monitors "$src_mon" "$dst_mon"

    fi

    bspc node @/ -B
fi

