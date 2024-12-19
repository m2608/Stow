function fzf-dict -d "View json dictionary with fzf"
    if test -f "$argv[1]"
        set filename "$argv[1]"
        set query "$argv[2]"

        set style (background)

        cat "$filename" \
        | jq -r .key \
        | fzf                                    \
            --query "$query"                     \
            --preview "jq -r 'select(.key == \"'{}'\") | .value' '$filename' | html2text -from_encoding utf-8 | glow --style=$style" \
            --preview-window "up:80%"            \
            --bind "up:preview-up"               \
            --bind "down:preview-down"           \
            --bind "page-up:preview-page-up"     \
            --bind "page-down:preview-page-down" \
            --bind "home:preview-top"            \
            --bind "end:preview-bottom"                      
    end
end
