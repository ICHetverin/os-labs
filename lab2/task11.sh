#!/bin/bash

max_pid=""
max_resident=0

for statm_file in /proc/[0-9]*/statm; do
    pid="${statm_file%/statm}"
    pid="${pid##*/}"
    read -r _size resident _ < "$statm_file" 2>/dev/null || continue
    if [ "$resident" -gt "$max_resident" ] 2>/dev/null; then
        max_resident=$resident
        max_pid=$pid
    fi
done

page_kb=4
mem_kb=$((max_resident * page_kb))

echo "=== /proc: процесс с наибольшим объёмом RAM ==="
echo "PID           : $max_pid"
echo "RSS (страниц) : $max_resident"
echo "RSS (KB)      : $mem_kb"
echo ""
grep -E "^(Name|VmRSS|VmSize):" "/proc/$max_pid/status" 2>/dev/null
echo ""
echo "=== top (сортировка по RES, первые 15 строк) ==="
top -b -n 1 -o RES 2>/dev/null | head -15
