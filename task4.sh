#!/bin/bash
# Задание 4: анализ процесса sleep 10000

# 4.1 — создать процесс и перейти в /proc/<PID>/
sleep 10000 &
PID=$!
echo "Создан процесс sleep 10000, PID: $PID"
echo "Каталог: /proc/$PID/"
echo ""

sleep 0.2  # дать ядру время создать записи в /proc

# 4.2 — последние 5 строк стека вызовов
echo "=== 4.2: Последние 5 строк стека вызовов (/proc/$PID/stack) ==="
if [ -r "/proc/$PID/stack" ]; then
    tail -5 /proc/$PID/stack
else
    echo "(требуются права root; текущий syscall: $(cat /proc/$PID/wchan 2>/dev/null))"
fi
echo ""

# 4.3 — поля Name, PPid, Kthread и количество потоков
echo "=== 4.3: Поля из /proc/$PID/status ==="
grep -E "^(Name|PPid|Kthread|Threads):" /proc/$PID/status
echo ""

# 4.4 — сравнение Tgid и Pid
echo "=== 4.4: Tgid и Pid ==="
grep -E "^(Tgid|Pid):" /proc/$PID/status
echo ""
cat <<'EOF'
Объяснение: sleep — однопоточный процесс.
В Linux каждый поток имеет собственный Pid, а Tgid (Thread Group ID) указывает
на PID лидера группы потоков (главного потока).
У однопоточного процесса единственный поток является и лидером группы,
поэтому Tgid == Pid.
В многопоточных программах все потоки разделяют один Tgid (== PID main-потока),
но у каждого потока свой уникальный Pid.
EOF
echo ""

# Завершить созданный процесс
echo "Завершение процесса $PID..."
kill "$PID" 2>/dev/null
