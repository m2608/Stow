function clojuredocs -d "View clojuredocs"

    # Папка, где будем хранить данные.
    set folder "$HOME/.cache/clojuredocs"

    # Путь к файлу для скачивания clojuredocs.
    set filename "$folder/clojuredocs-export.json"

    # URL для скачивания.
    set url "https://clojuredocs.org/clojuredocs-export.json"

    # Проверяем, что каталог существует.
    test -d "$folder" ; or mkdir -p "$folder"

    # Флаг, нужно ли обновлять файл.
    set update 1

    # Файл должен существовать и быть ненулевого размера.
    if test -e "$filename" -a -s "$filename"
        # Определяем таймстамп файла на сервере из заголовка Last-Modified.
        set timestamp_remote (xh head --print=h "$url" \
            | jq -Rr -s 'split("\n") 
                | map(capture("(?<key>[^:]+): (?<value>.*)"))
                | from_entries
                | .["last-modified"]
            ' | LC_ALL=C xargs -I{} date -j -f "%a, %d %b %Y %H:%M:%S %Z" {} "+%s")

        # Определяем таймстамп локального файла.
        set timestamp_local (stat -f "%m" "$filename")

        if test $timestamp_remote -le $timestamp_local
            set update 0
        end
    end

    # Скачиваем файл, если нужно.
    if test $update -eq 1
        xh --download --output "$filename" "$url"
    end

    set style (background)

    set jq_command '.vars
        | map(select("\(.ns)/\(.name)" == "{}"))
        | first
        | .name as $name
        | [
            "## Documentation",
            (foreach .arglists[] as $args (0; . + 1; "\(.). (\($name) \($args))")),
            "\(.doc)",
            (foreach .examples[]? as $example (0; . + 1; "## Example \(.)\n```clojure\n\($example | .body)\n```"))
        ] | join("\n\n")
    '

    cat "$filename" \
    | jq -r '.vars | map("\(.ns)/\(.name)") | .[]' \
    | fzf \
        --preview "jq -r '$jq_command' '$filename' | rich --markdown --force-terminal -" \
        --preview-window "up:80%"            \
        --bind "up:preview-up"               \
        --bind "down:preview-down"           \
        --bind "page-up:preview-page-up"     \
        --bind "page-down:preview-page-down" \
        --bind "home:preview-top"            \
        --bind "end:preview-bottom"

    # Всегда возвращаем 0 статус, даже если ничего не было выбрано.
    return 0
end
