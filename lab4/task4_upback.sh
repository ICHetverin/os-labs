#!/bin/bash
# Восстанавливает файлы из резервной копии в ~/restore/.
# Ищет наиболее свежую резервную копию: сначала ~/Backup-YYYY-MM-DD,
# затем ~/backup. Копирует содержимое в ~/restore/.

RESTORE_DIR="$HOME/restore"
DATE=$(date +%Y-%m-%d)
DATED_BACKUP="$HOME/Backup-$DATE"
FALLBACK_BACKUP="$HOME/backup"

# Определяем источник резервной копии (не пустой)
if [ -d "$DATED_BACKUP" ] && [ -n "$(ls -A "$DATED_BACKUP" 2>/dev/null)" ]; then
    SOURCE="$DATED_BACKUP"
elif [ -d "$FALLBACK_BACKUP" ] && [ -n "$(ls -A "$FALLBACK_BACKUP" 2>/dev/null)" ]; then
    SOURCE="$FALLBACK_BACKUP"
else
    # Ищем самый свежий каталог Backup-*
    SOURCE=$(find "$HOME" -maxdepth 1 -name 'Backup-*' -type d | sort | tail -1)
    if [ -z "$SOURCE" ]; then
        echo "upback: резервная копия не найдена" >&2
        exit 1
    fi
fi

mkdir -p "$RESTORE_DIR"
cp -r "$SOURCE/." "$RESTORE_DIR/"

echo "Восстановлено из: $SOURCE"
echo "Восстановлено в:  $RESTORE_DIR"
echo ""
echo "Восстановленные файлы:"
find "$RESTORE_DIR" -type f | sort | while read -r f; do
    echo "  ${f#$RESTORE_DIR/}"
done
