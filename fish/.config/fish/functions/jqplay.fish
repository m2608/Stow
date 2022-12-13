function jqplay -d "Run jq REPL"
    if test -f $argv[1]
        set filename $argv[1]

        if test -n $argv[2]
            set query $argv[2]
        else
            set query "."
        end

        jq "." "$filename" \
        | fzf \
            --disabled \
            --print-query \
            --preview "jq -C {q} \"$filename\"" \
            --query="$query" \
            --bind "up:preview-up,down:preview-down,page-up:preview-page-up,page-down:preview-page-down,home:preview-top,end:preview-bottom" \
            --no-sort \
            --tac \
        | head -1
    end
end
