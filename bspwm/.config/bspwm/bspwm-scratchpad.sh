#!/bin/sh

# открывает маленькое окошко в центре экрана
# подразумевается использовать скрипт для быстрого открытия терминала

# размеры окна по умолчанию
width=1400
height=1000

while test $# -gt 0; do
    case "$1" in
        # класс окна
        --class)
            class="$2"
            shift; shift
            ;;
        # команда для запуска
        -c|--command)
            command="$2"
            shift; shift
            ;;
        # ширина окна
        -w|--width)
            width="$2"
            shift; shift
            ;;
        # высота окна
        -h|--height)
            height="$2"
            shift; shift
            ;;
        *)
            exit 0
            ;;
    esac
done

# класс и команда - обязательные параметры
test -n "$class" -a -n "$command" || exit 0

# ищем окно с указанным классом и получаем информацию о нем
sp_data=$(                                                \
    bspc query -N                                         \
        | xargs -I{} bspc query -T -n {}                  \
        | jq "select(.client.className == \"$class\")" \
    )

if test -n "$sp_data"; then
    sp_id=$(    echo "$sp_data" | jq ".id")
    sp_hidden=$(echo "$sp_data" | jq ".hidden")

    # показываем или скрываем найденную ноду
    bspc node "$sp_id" --flag hidden

    if test "$sp_hidden" = "true"; then
        bspc node --focus "$sp_id"
    fi
else
    # если окна с указанным классом нет - создаем новую ноду
    bspc rule -a "$class" -o               \
        state=floating                     \
        sticky=on                          \
        center=on                          \
        layer=above                        \
        rectangle="${width}x${height}+0+0" \
        && exec sh -c "$command"
fi

