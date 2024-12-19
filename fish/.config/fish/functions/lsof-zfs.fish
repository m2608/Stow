function lsof-zfs -d "Посмотреть список открытых файлов (lsof не поддерживает zfs)"
    ps ax -o pid= | xargs procstat -f 2>/dev/null
end
