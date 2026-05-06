#!/bin/bash

BINARY="./troubleshooting"

if [ ! -f "$BINARY" ]; then
    echo "Ошибка: файл $BINARY не найден"
    exit 1
fi

chmod +x "$BINARY"

echo "Запись сетевых операций в troubleshooting_network.log ..."
strace -e trace=network -o troubleshooting_network.log "$BINARY"

echo "Запись файловых операций в troubleshooting_file.log ..."
strace -e trace=file -o troubleshooting_file.log "$BINARY"

echo ""
echo "Готово."
echo "  Сетевые операции : troubleshooting_network.log"
echo "  Файловые операции: troubleshooting_file.log"
