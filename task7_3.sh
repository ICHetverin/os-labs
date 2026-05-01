#!/bin/bash
# Задание 7.3: определить обрабатываемый пользовательский сигнал и отправить противоположный
#
# Шаг 1 — запустить программу с strace для анализа регистрации сигналов:
#   strace -e trace=rt_sigaction -o /tmp/sig_analysis.log ./troubleshooting
#
# Шаг 2 — посмотреть, для какого SIGUSR установлен пользовательский обработчик
#   (не SIG_DFL и не SIG_IGN):
#   grep -E "SIGUSR[12]" /tmp/sig_analysis.log
#
# Шаг 3 — запустить программу в терминале 1:
#   ./troubleshooting
#
# Шаг 4 — в терминале 2 отправить ПРОТИВОПОЛОЖНЫЙ сигнал:
#   kill -SIGUSR2 <PID>   # если обрабатывается SIGUSR1
#   kill -SIGUSR1 <PID>   # если обрабатывается SIGUSR2
#
# Ниже — автоматизированный вариант:

BINARY="./troubleshooting"

if [ ! -f "$BINARY" ]; then
    echo "Ошибка: файл $BINARY не найден"
    exit 1
fi

chmod +x "$BINARY"

echo "Анализ обработчиков сигналов через strace..."
strace -e trace=rt_sigaction -o /tmp/sig_analysis.log "$BINARY" &
PROG_PID=$!
sleep 1  # дать программе зарегистрировать обработчики

# Определить, какой SIGUSR обрабатывается (имеет пользовательский обработчик)
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
