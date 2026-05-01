#!/bin/bash
# Задание 8: запустить top_troubleshooting и наблюдать за происходящим через top

BINARY="./top_troubleshooting"

if [ ! -f "$BINARY" ]; then
    echo "Ошибка: файл $BINARY не найден"
    exit 1
fi

chmod +x "$BINARY"

echo "Запуск $BINARY ..."
"$BINARY" &
PROG_PID=$!
echo "PID: $PROG_PID"
echo ""
echo "Наблюдение (каждую секунду, 15 итераций):"
echo "  PID        RSS(KB)  VSZ(KB)  STAT  COMMAND"

for i in $(seq 1 15); do
    ps -p "$PROG_PID" -o pid,rss,vsz,stat,comm --no-headers 2>/dev/null \
        || { echo "Процесс $PROG_PID завершился на итерации $i"; break; }
    sleep 1
done

echo ""
echo "Открытые файловые дескрипторы процесса:"
ls -la "/proc/$PROG_PID/fd/" 2>/dev/null || echo "(процесс уже завершён)"

wait "$PROG_PID"
echo "Код завершения: $?"

# Ожидаемое поведение:
# top_troubleshooting непрерывно растёт в потреблении RSS/VSZ — признак утечки памяти.
# Через некоторое время процесс может быть завершён OOM-killer'ом,
# либо связанный файл (если программа пишет данные) будет расти до заполнения диска.
# Именно это и нужно описать по результатам наблюдения в top.
