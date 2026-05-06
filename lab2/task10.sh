#!/bin/bash

INPUT="${1:-task9_output.txt}"
OUTPUT="task10_output.txt"

if [ ! -f "$INPUT" ]; then
    echo "Файл $INPUT не найден. Сначала запустите task9.sh."
    exit 1
fi

: > "$OUTPUT"

current_ppid=""
sum_art="0"
count=0
declare -a group_lines=()

flush_group() {
    if [ "${#group_lines[@]}" -gt 0 ]; then
        printf '%s\n' "${group_lines[@]}" >> "$OUTPUT"
        avg=$(awk "BEGIN {printf \"%.6f\", $sum_art / $count}")
        echo "Average_Running_Children_of_ParentID=$current_ppid is $avg" >> "$OUTPUT"
        group_lines=()
    fi
}

while IFS= read -r line; do
    ppid=$(echo "$line" | grep -o 'Parent_ProcessID=[0-9]*' | cut -d= -f2)
    art=$(echo "$line"  | grep -o 'Average_Running_Time=[0-9.]*' | cut -d= -f2)

    if [ "$ppid" != "$current_ppid" ]; then
        flush_group
        current_ppid="$ppid"
        sum_art="$art"
        count=1
    else
        sum_art=$(awk "BEGIN {print $sum_art + $art}")
        count=$((count + 1))
    fi
    group_lines+=("$line")
done < "$INPUT"

flush_group

echo "Готово. Файл: $OUTPUT"
echo "Строк: $(wc -l < "$OUTPUT")"
