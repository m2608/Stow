#!/bin/sh

port_default=9

if test -z $2; then
    echo Usage: $0 \<MAC\> \<broadcast\> \[port\]
    exit 1
fi

mac=$(echo $1 | tr -d ':')
ip="$2"
port=$(test -n "$3" && echo "$3" || echo "$port_default")

# Magic packets consist of 12*`f` followed by 16 repetitions of the MAC address
magic_packet=$(
  printf "f%.0s"    $(seq 12)
  printf "$mac%.0s" $(seq 16)
)

printf "$magic_packet" | xxd -r -ps | nc -w1 -u $ip $port

