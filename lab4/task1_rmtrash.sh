#!/bin/bash
# Перемещает файл(ы) в корзину (~/.trash) вместо удаления.
# Логирует исходный путь, время и имя в ~/.trash/trash.log

TRASH="$HOME/.trash"
LOG="$TRASH/trash.log"

mkdir -p "$TRASH"

if [ $# -eq 0 ]; then
    echo "Использование: $0 <файл> [файл ...]" >&2
    exit 1
fi

for target in "$@"; do
    if [ ! -e "$target" ]; then
        echo "rmtrash: '$target': нет такого файла или каталога" >&2
        continue
    fi

    abs_path=$(readlink -f "$target")
    base=$(basename "$abs_path")
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    # Разрешаем конфликты имён в корзине
    dest="$TRASH/$base"
    counter=1
    while [ -e "$dest" ]; do
        dest="$TRASH/${base}.${counter}"
        counter=$((counter + 1))
    done

    mv "$abs_path" "$dest"
    echo "$timestamp | $abs_path | $(basename "$dest")" >> "$LOG"
    echo "Перемещено в корзину: $target"
done
