function fzf-pipe -d "Run file through commands"
    if test -f "$argv[1]"
        set filename "$argv[1]"

        cat "$filename" \
        | fzf           \
            --disabled                                                 \
            --print-query                                              \
            --query "cat"                                              \
            --preview "cat '$filename' | sh -c {q}"                    \
            --preview-window "up:99%"                                  \
            --bind "up:preview-up"                                     \
            --bind "down:preview-down"                                 \
            --bind "page-up:preview-page-up"                           \
            --bind "page-down:preview-page-down"                       \
            --bind "home:preview-top"                                  \
            --bind "end:preview-bottom"                                \
            --bind "alt-e:execute(cat '$filename' | sh -c {q} | nvim)" \
            --bind "alt-q:execute(echo {q} | nvim)"                    \
            --no-sort                                                  \
            --tac                                                      \
        | head -1
    end
end


