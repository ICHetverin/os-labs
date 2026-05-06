#!/bin/bash
# Резервное копирование ~/source в ~/backup.
#
# a) Создаёт каталог ~/Backup-YYYY-MM-DD
# b) Копирует ~/source/ в ~/backup/ и формирует отчёт ~/backup/report
# c) Создаёт версионированную копию ~/source.YYYY-MM-DD и обновляет отчёт

DATE=$(date +%Y-%m-%d)
SOURCE="$HOME/source"
BACKUP_DIR="$HOME/Backup-$DATE"
BACKUP_DEST="$HOME/backup"
REPORT="$BACKUP_DEST/report"

# --- a) Создание датированного каталога ---
if [ -d "$BACKUP_DIR" ]; then
    echo "[a] Каталог уже существует: $BACKUP_DIR"
else
    mkdir -p "$BACKUP_DIR"
    echo "[a] Создан каталог резервной копии: $BACKUP_DIR"
fi

# --- b) Копирование source -> backup + отчёт ---
if [ ! -d "$SOURCE" ]; then
    echo "[b] Исходный каталог не найден: $SOURCE" >&2
    exit 1
fi

mkdir -p "$BACKUP_DEST"
cp -r "$SOURCE/." "$BACKUP_DEST/"

{
    echo "Отчёт о резервном копировании — $(date)"
    echo "Источник:      $SOURCE"
    echo "Назначение:    $BACKUP_DEST"
    echo "---"
    find "$SOURCE" -type f | sort | while read -r f; do
        size=$(stat -c '%s' "$f")
        rel="${f#$SOURCE/}"
        printf '%8d  %s\n' "$size" "$rel"
    done
} > "$REPORT"

echo "[b] Копирование завершено. Отчёт: $REPORT"

# --- c) Версионированная копия source.YYYY-MM-DD + обновлённый отчёт ---
VERSIONED="$HOME/source.$DATE"
if [ -d "$VERSIONED" ]; then
    echo "[c] Версионированная копия уже существует: $VERSIONED"
else
    cp -r "$SOURCE" "$VERSIONED"
    echo "[c] Создана версионированная копия: $VERSIONED"
fi

{
    echo ""
    echo "Версионированная копия: $VERSIONED"
    find "$VERSIONED" -type f | sort | while read -r f; do
        size=$(stat -c '%s' "$f")
        rel="${f#$VERSIONED/}"
        printf '%8d  %s\n' "$size" "$rel"
    done
} >> "$REPORT"

echo "[c] Отчёт обновлён: $REPORT"
