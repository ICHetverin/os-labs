#!/bin/bash

if [ -z "$1" ]; then
    echo "Использование: $0 <N_секунд> [nice_значение]"
    echo "  N_секунд   : изменить приоритет процессов, работающих дольше N секунд"
    echo "  nice_значение: новый nice (по умолчанию 10; диапазон -20..19)"
    exit 1
fi

N="$1"
NICE_VAL="${2:-10}"

echo "Renice до nice=$NICE_VAL для процессов с etimes > ${N}s ..."
echo ""

ps -eo pid,etimes --no-headers | while read -r pid elapsed; do
    [ "$pid" -le 1 ] && continue
    if [ "$elapsed" -gt "$N" ] 2>/dev/null; then
        if renice "$NICE_VAL" -p "$pid" 2>/dev/null; then
            echo "  PID $pid (работает ${elapsed}s) → nice=$NICE_VAL"
        fi
    fi
done

echo ""
echo "=== Проверка: ps -eo pid,ni,etimes,comm (топ 20 по времени) ==="
ps -eo pid,ni,etimes,comm --no-headers | sort -k3 -nr | head -20
