#!/bin/bash
# Восстанавливает файл из корзины (~/.trash).
# Без аргумента — интерактивный режим со списком содержимого корзины.
# С аргументом — восстанавливает указанный файл по оригинальному пути из trash.log.

TRASH="$HOME/.trash"
LOG="$TRASH/trash.log"

if [ $# -eq 0 ]; then
    # Интерактивный режим
    if [ ! -d "$TRASH" ] || [ -z "$(ls -A "$TRASH" 2>/dev/null | grep -v '^trash\.log$')" ]; then
        echo "Корзина пуста."
        exit 0
    fi
    echo "Содержимое корзины:"
    ls "$TRASH" | grep -v '^trash\.log$'
    echo ""
    read -rp "Введите имя файла для восстановления: " fname
else
    fname="$1"
fi

[ -z "$fname" ] && { echo "Имя файла не указано." >&2; exit 1; }

file_in_trash="$TRASH/$fname"
if [ ! -e "$file_in_trash" ]; then
    echo "untrash: '$fname' не найден в корзине" >&2
    exit 1
fi

# Ищем оригинальный путь в trash.log
orig_path=""
if [ -f "$LOG" ]; then
    orig_path=$(grep -F "| $fname" "$LOG" | tail -1 | cut -d'|' -f2 | xargs)
fi

if [ -n "$orig_path" ]; then
    dest_dir=$(dirname "$orig_path")
    mkdir -p "$dest_dir"
    mv "$file_in_trash" "$orig_path"
    # Убираем запись из лога
    grep -vF "| $fname" "$LOG" > "${LOG}.tmp" 2>/dev/null && mv "${LOG}.tmp" "$LOG"
    echo "Восстановлено: $fname -> $orig_path"
else
    mv "$file_in_trash" "./$fname"
    echo "Восстановлено в текущий каталог: $(pwd)/$fname"
fi
