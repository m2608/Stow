function epy-zip -a filename -d "Open zipped fs2 book with epy-reader"
    if echo "$filename" | grep -q '\.fb2\.zip$'
        epy (unzip -p "$filename" | psub -s .fb2)
    else
        printf "Filename \"$filename\" doesn't look like zipped fb2 book." "$filename"
        exit 1
    end
end
