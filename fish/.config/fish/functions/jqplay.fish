function jqplay -d "Run jq REPL"
    if test -f $argv[1]
        set filename $argv[1]

        jq "." "$filename" \
        | fzf \
            --disabled \
            --print-query \
            --preview "jq -C {q} \"$filename\"" \
            --preview-window "up:99%" \
            --bind "up:preview-up,down:preview-down,page-up:preview-page-up,page-down:preview-page-down,home:preview-top,end:preview-bottom" \
            --no-sort \
            --tac \
        | head -1
    end
end
