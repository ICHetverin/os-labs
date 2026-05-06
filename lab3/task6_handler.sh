#!/bin/bash

PID_FILE=/tmp/task6_handler.pid
echo $$ > "$PID_FILE"

VALUE=1
OP="add"

on_usr1() { OP="add"; }
on_usr2() { OP="multiply"; }
on_term() {
    echo "Stopped by SIGTERM from another process."
    rm -f "$PID_FILE"
    exit 0
}

trap 'on_usr1' USR1
trap 'on_usr2' USR2
trap 'on_term' TERM

while true; do
    case "$OP" in
        "add")      VALUE=$((VALUE + 2)) ;;
        "multiply") VALUE=$((VALUE * 2)) ;;
    esac
    echo "$VALUE"
    sleep 1
done
