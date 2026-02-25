function chplay -d "Run REPL for clickhouse local with JSONLines input format"
    if test -f "$argv[1]"
        set filename "$argv[1]"
        set query "$argv[2]"

        cat "$filename"                                                                                             \
        | fzf                                                                                                       \
            --disabled                                                                                              \
            --print-query                                                                                           \
            --query "$query"                                                                                        \
            --preview "clickhouse local --input-format JSONLines --file '$filename' --query {q}"                    \
            --preview-window "up:99%"                                                                               \
            --bind "up:preview-up"                                                                                  \
            --bind "down:preview-down"                                                                              \
            --bind "page-up:preview-page-up"                                                                        \
            --bind "page-down:preview-page-down"                                                                    \
            --bind "home:preview-top"                                                                               \
            --bind "end:preview-bottom"                                                                             \
            --bind "alt-e:execute(clickhouse local --input-format JSONLines --file '$filename' --query {q} | nvim)" \
            --bind "alt-q:execute(echo {q} | nvim -c 'set ft=sql')"                                                 \
            --bind "alt-w:toggle-preview-wrap"                                                                      \
            --no-sort                                                                                               \
            --tac                                                                                                   \
        | head -1
    end
end


