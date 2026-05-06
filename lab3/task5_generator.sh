#!/bin/bash

PIPE=/tmp/task5_pipe
[ -p "$PIPE" ] || mkfifo "$PIPE"
echo $$ > /tmp/task5_gen.pid

while true; do
    read -r LINE
    echo "$LINE" > "$PIPE"
    [ "$LINE" = "QUIT" ] && break
done

rm -f /tmp/task5_gen.pid
