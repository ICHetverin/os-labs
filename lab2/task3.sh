#!/bin/bash

ps -eo pid,etimes --no-headers | sort -k2 -n | awk 'NR==1 {print $1}'
