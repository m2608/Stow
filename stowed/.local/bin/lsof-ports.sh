#!/bin/sh

lsof -i -P -n \
| jc --lsof \
| jq -r '[.[] | select(.name | test("LISTEN"))]
    | unique_by(.name)
    | sort_by(.command)
    | .[]
    | [.command,
       .user,
       (.name | sub("(?<host>.*):(?<port>[0-9]+).*"; "\(.host)", "\(.port)"))]
    | @tsv' \
| pspg --tsv
