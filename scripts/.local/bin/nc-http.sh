#!/bin/sh

self=`basename "$0"`
help="Usage: $self [-b|--bind <ip address>] [-p|--port <port>] [-l|--log-file <log file>] <file>"

while test $# -gt 0; do
    case "$1" in
        -b|--bind)
            host="$2"
            shift
            shift
            ;;
        -p|--port)
            port="$2"
            shift
            shift
            ;;
        -l|--log-file)
            logfile="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "$help"
            exit 1
            ;;
        *)
            file="$1"
            shift
            break
            ;;
    esac
done

if test "$host" = ""; then
    host="127.0.0.1"
fi

if test "$port" = ""; then
    port="8000"
fi

if test "$file" = "" ; then 
    echo "$help"
    exit 1
fi

if test "$logfile" = ""; then
    logfile="/dev/stdout"
fi

if ! test -f "$file"; then
    echo "File \"$file\" not found."
    exit 1
fi

pidfile=/tmp/nchttp-$port.pid

mimetype=`mimetype --output-format "%m" -L "$file"`

echo Serving $file at $host:$port, mimetype: $mimetype, pid: $$
echo $$ > $pidfile

while true; do 
    length=`wc -c $file | cut -w -f 2`
    filename=`basename $file`
    printf "HTTP/1.0 200 OK\r\nContent-Length: %d\r\nContent-Type: $mimetype\r\nContent-Disposition: inline; filename=\"%s\"\r\n\r\n" $length $filename \
        | cat - $file \
        | nc -v -l $host $port \
        >> $logfile 
    code=$?
    if test $code -gt 128; then 
        break
    fi
done

rm $pidfile
