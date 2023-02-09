function find-methods -d "Find methods from file."
    if test -f $argv[1]
        set filename $argv[1]

        echo "<table>"
        echo "<thead><tr><th>Название метода</th><th>Репозиторий</th></tr></thead>"
        echo "<tbody>"

        rg -g '*.orx' --json -F -f \
            (for method in (cat methods.txt); echo "name=\"$method\""; echo "alias=\"$method\""; end | psub) \
            | jq -c '
                select(.type=="match") 
                | {
                    file: .data.path.text,
                    line: .data.line_number,
                    meth: (.data.submatches[0].match.text | sub("^(name|alias)=\""; "") | sub("\"$"; ""))
                }
            ' \
            | while read match
                set file (echo "$match" | jq -r '.file')
                set line (echo "$match" | jq -r '.line')
                set meth (echo "$match" | jq -r '.meth')
                set link (git-browse --show "$file" $line)
                set repo (echo "$link" | sed -r 's#^(http[s]?://([^/]+/){3}).*#\1#')
                set name (echo "$repo" | sed -r 's#^.*/(([^/]+/){2})#\1#' | sed 's#/$##')

                echo "<tr>"
                printf '<td><a href="%s">%s</a></td>\n' "$link" "$meth"
                printf '<td><a href="%s">%s</a></td>\n' "$repo" "$name"
                echo "</tr>"
            end

        echo "</tbody>"
        echo "</table>"
    end
end
