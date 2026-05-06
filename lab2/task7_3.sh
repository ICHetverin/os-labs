#!/bin/bash

BINARY="./troubleshooting"

if [ ! -f "$BINARY" ]; then
    echo "Ошибка: файл $BINARY не найден"
    exit 1
fi

chmod +x "$BINARY"

echo "Анализ обработчиков сигналов через strace..."
strace -e trace=rt_sigaction -o /tmp/sig_analysis.log "$BINARY" &
PROG_PID=$!
sleep 1

if grep -q "SIGUSR1" /tmp/sig_analysis.log && \
   ! grep "SIGUSR1" /tmp/sig_analysis.log | grep -qE "SIG_DFL|SIG_IGN"; then
    HANDLED="SIGUSR1"
    OPPOSITE="SIGUSR2"
else
    HANDLED="SIGUSR2"
    OPPOSITE="SIGUSR1"
fi

echo "Обрабатываемый сигнал: $HANDLED"
echo "Отправляем противоположный сигнал $OPPOSITE процессу $PROG_PID..."
kill -"$OPPOSITE" "$PROG_PID" 2>/dev/null

wait "$PROG_PID"
EXIT_CODE=$?
echo "Код завершения: $EXIT_CODE"
