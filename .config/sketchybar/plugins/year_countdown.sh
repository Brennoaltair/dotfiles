#!/bin/bash

END=$(date -j -f "%Y-%m-%d" "$(date +%Y)-12-31" +%s)
NOW=$(date +%s)
DAYS=$(( (END - NOW) / 86400 ))
sketchybar --set "$NAME" label="${DAYS}d"
