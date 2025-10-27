function epy-zip -a filename -d "Open zipped or regular fb2 with epy-reader"
    set cmd (command -v epy)

    if string match -r '[.](fb2|epub)$' "$filename"
        $cmd "$filename"
    else if string match -r '[.]fb2[.]zip$' "$filename"
        $cmd (unzip -p "$filename" | psub -s .fb2)
    else if string match -r '[.]epub[.]zip$' "$filename"
        $cmd (unzip -p "$filename" | psub -s .epub)
    else
        printf "File %s is not supported.\n" "$filename"
        exit 1
    end
end
