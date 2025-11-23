#!/bin/sh

self=`basename $0`

if test -z "$1" -o -z "$2" -o ! -f "$1"; then
    echo Usage: "$self <file name> <command>"
    exit 0
fi

filename="$1"
command="$2"
shift

### Set initial time of file
ltime=`stat -c %Z "$filename"`

while true    
do
   atime=`stat -c %Z "$filename"`

   if test "$atime" != "$ltime"; then
       printf "\n/// %s EXECUTE\n\n" "$self"
       /bin/sh -c "$command"
       ltime=$atime
   fi
   sleep 1
done
