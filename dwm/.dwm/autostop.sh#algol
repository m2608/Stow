#!/bin/sh

# Останавливаем сервисы, запущенные при старте оконного менеджера.
for pid in `pgrep runsvdir`; do
    kill -HUP $pid
done
