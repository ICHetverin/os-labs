#!/bin/bash

ps -eo pid,stat --no-headers | awk '$2 ~ /^[RSDZT]/ {print $1}'
