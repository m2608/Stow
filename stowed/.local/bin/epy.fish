#!/usr/bin/env fish

if test -z "$argv[1]"
    printf "Usage: %s <filename>\n" "$argv[0]"
    exit 0
end

set filename "$argv[1]"

if ! test -e "$filename"
    printf "File does not exist: %s\n" "$filename"
    exit 1
end

if ! string match -q -r '[.](fb2|epub)([.]zip)?$' "$filename"
    printf "File is not supported: %s\n" "$filename"
    exit 2
end

set cmd (command -v epy)

if string match -q -r '[.]fb2[.]zip$' "$filename"
    $cmd (unzip -p "$filename" | psub -s .fb2)
else if string match -q -r '[.]epub[.]zip$' "$filename"
    $cmd (unzip -p "$filename" | psub -s .epub)
else
    $cmd "$filename"
end
