#!/bin/bash
# Задание 9: среднее время непрерывного использования CPU для всех процессов
# Формат: ProcessID=PID : Parent_ProcessID=PPID : Average_Running_Time=ART
# ART = sum_exec_runtime / nr_switches (из /proc/<PID>/sched)
# PPid — из /proc/<PID>/status
# Вывод отсортирован по PPID

OUTPUT="task9_output.txt"
: > "$OUTPUT"

for pid_dir in /proc/[0-9]*/; do
    pid="${pid_dir%/}"
    pid="${pid##*/}"

    status_file="${pid_dir}status"
    sched_file="${pid_dir}sched"

    [ -f "$status_file" ] || continue
    [ -f "$sched_file" ]  || continue

    ppid=$(awk '/^PPid:/ {print $2; exit}' "$status_file" 2>/dev/null)
    [ -z "$ppid" ] && continue

    sum_exec=$(awk '/^se\.sum_exec_runtime/ {print $NF; exit}' "$sched_file" 2>/dev/null)
    nr_switches=$(awk '/^nr_switches/ {print $NF; exit}' "$sched_file" 2>/dev/null)

    [ -z "$sum_exec" ] || [ -z "$nr_switches" ] && continue

    nr_int=$(printf "%.0f" "$nr_switches" 2>/dev/null)
    [ "$nr_int" -le 0 ] 2>/dev/null && continue

    art=$(awk "BEGIN {printf \"%.6f\", $sum_exec / $nr_switches}")

    echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art"
done | sort -t= -k3 -n > "$OUTPUT"

echo "Готово. Записей: $(wc -l < "$OUTPUT")"
echo "Файл: $OUTPUT"
