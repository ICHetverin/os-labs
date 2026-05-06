#!/bin/bash

PID_FILE=/tmp/task6_handler.pid

while [ ! -f "$PID_FILE" ]; do
    sleep 0.2
done
HANDLER_PID=$(cat "$PID_FILE")

while true; do
    read -r LINE
    case "$LINE" in
        "+")    kill -USR1 "$HANDLER_PID" 2>/dev/null ;;
        "*")    kill -USR2 "$HANDLER_PID" 2>/dev/null ;;
        "TERM")
            kill -TERM "$HANDLER_PID" 2>/dev/null
            echo "SIGTERM sent. Generator exiting."
            exit 0
            ;;
    esac
done
