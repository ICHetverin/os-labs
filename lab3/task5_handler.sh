#!/bin/bash

PIPE=/tmp/task5_pipe
[ -p "$PIPE" ] || mkfifo "$PIPE"

MODE="add"
VALUE=1

stop_generator() {
    GEN_PID=$(cat /tmp/task5_gen.pid 2>/dev/null)
    [ -n "$GEN_PID" ] && kill "$GEN_PID" 2>/dev/null
    rm -f /tmp/task5_gen.pid
}

(tail -f "$PIPE") | while IFS= read -r LINE; do
    case "$LINE" in
        "+")
            MODE="add"
            echo "Mode: addition"
            ;;
        "*")
            MODE="multiply"
            echo "Mode: multiplication"
            ;;
        "QUIT")
            echo "Planned stop. Final value: $VALUE"
            stop_generator
            exit 0
            ;;
        *)
            if [[ "$LINE" =~ ^-?[0-9]+$ ]]; then
                case "$MODE" in
                    "add")      VALUE=$((VALUE + LINE)) ;;
                    "multiply") VALUE=$((VALUE * LINE)) ;;
                esac
                echo "Result: $VALUE"
            else
                echo "Error: invalid input '$LINE'"
                stop_generator
                exit 1
            fi
            ;;
    esac
done
