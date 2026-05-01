#!/bin/bash
# Задание 5: завершить процессы, работающие менее N секунд; PID записать в killed.log
# Использование: bash task5.sh <N>

if [ -z "$1" ]; then
    echo "Использование: $0 <N_секунд>"
    exit 1
fi

N="$1"
> killed.log

ps -eo pid,etimes --no-headers | while read -r pid elapsed; do
    [ "$pid" -le 1 ] && continue        # пропустить init/systemd
    [ "$pid" -eq "$$" ] && continue     # пропустить текущий скрипт
    if [ "$elapsed" -lt "$N" ] 2>/dev/null; then
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null && echo "$pid" >> killed.log
        fi
    fi
done

echo "Завершённые процессы записаны в killed.log:"
cat killed.log
