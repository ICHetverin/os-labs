#!/bin/bash

WORKER="$(dirname "$(realpath "$0")")/task4_worker.sh"

bash "$WORKER" &
PID1=$!
bash "$WORKER" &
PID2=$!
bash "$WORKER" &
PID3=$!

echo "Workers: PID1=$PID1  PID2=$PID2  PID3=$PID3"
echo "Kill process 3 with: kill -SIGTERM $PID3"
echo "Throttling PID1=$PID1 to ~10% CPU..."

while kill -0 "$PID1" 2>/dev/null; do
    kill -CONT "$PID1" 2>/dev/null
    sleep 0.1
    kill -STOP "$PID1" 2>/dev/null
    sleep 0.9
done

echo "PID1 has exited."
