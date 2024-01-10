#!/bin/sh

# Скрипт позволяет табуляризовать данные, переданные на stdin с помощью
# плагина Tabular nvim'а.

# Первый параметр - регулярное выражение для определения разделителя.
# Второй параметр - форматная строка.

# Примеры:

# tabularize.sh ','
# tabularize.sh ',\zs' 'l1r0'

test -n "$1" || exit 1
regex="$1"

shift

format=""
if test -n "$1"; then
  format="$1"
fi

# Создаем временный файл.
TMPFILE=$(mktemp)

# Сохраняем в него входные данные.
cat > ${TMPFILE}

# Форматируем и сохраняем код выхода.
nvim --headless ${TMPFILE} -c ":%Tabularize /$regex/$format" -c ":wq" 2> /dev/null
status=$?

# Если ошибок не было, выводим результат выполнения команды.
if test $status = 0; then
  cat ${TMPFILE}
fi

# Удаляем временный файл и устанавливаем код выхода.
rm ${TMPFILE}
exit $status
