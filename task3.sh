#!/bin/bash
# Задание 3: вывести PID последнего запущенного процесса
# Наименьшее etimes — процесс запущен позже всех остальных
ps -eo pid,etimes --no-headers | sort -k2 -n | awk 'NR==1 {print $1}'
