#!/bin/bash

printf "%-10s %s\n" "PID" "RSS_KB"
ps -eo pid,rss --no-headers | sort -k2 -nr | while read -r pid rss; do
    printf "%-10s %s\n" "$pid" "$rss"
done
