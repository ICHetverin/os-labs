#!/bin/bash

at now + 2 minutes -f "$(realpath "$(dirname "$0")/task1.sh")"
tail -f ~/report
