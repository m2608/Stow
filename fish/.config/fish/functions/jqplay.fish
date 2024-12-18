function jqplay -d "Run jq REPL"
    if test -f "$argv[1]"
        set filename "$argv[1]"
        set query "$argv[2]"

        cat "$filename"                                                        \
        | fzf                                                                  \
            --disabled                                                         \
            --print-query                                                      \
            --query "$query"                                                   \
            --preview "jq -C {q} '$filename'"                                  \
            --preview-window "up:99%"                                          \
            --bind "up:preview-up"                                             \
            --bind "down:preview-down"                                         \
            --bind "page-up:preview-page-up"                                   \
            --bind "page-down:preview-page-down"                               \
            --bind "home:preview-top"                                          \
            --bind "end:preview-bottom"                                        \
            --bind "alt-e:execute(jq {q} '$filename' | nvim -c 'set ft=json')" \
            --bind "alt-q:execute(echo {q} | nvim -c 'set ft=jq')"             \
            --no-sort                                                          \
            --tac                                                              \
        | head -1
    end
end


