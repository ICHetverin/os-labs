#!/bin/bash

SCRIPT="$(realpath "$(dirname "$0")/task1.sh")"
DOW=$(date +%w)
(crontab -l 2>/dev/null; echo "5 * * * $DOW bash $SCRIPT") | crontab -
crontab -l
