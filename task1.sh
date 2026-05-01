#!/bin/bash
# Задание 1: вывести PID всех процессов со статусом R, S, D, Z или T
ps -eo pid,stat --no-headers | awk '$2 ~ /^[RSDZT]/ {print $1}'
