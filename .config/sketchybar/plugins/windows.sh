#!/bin/bash

VISIBLE_WS=$(aerospace list-workspaces --focused 2>/dev/null | tr -d '[:space:]')
APPS=$(aerospace list-windows --workspace "$VISIBLE_WS" --format "%{app-name}" 2>/dev/null | sort -u | tr '\n' '|' | sed 's/|$//;s/|/ · /g')

sketchybar --set "$NAME" label="${APPS:-}"
