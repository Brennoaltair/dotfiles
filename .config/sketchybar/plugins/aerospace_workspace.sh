#!/bin/bash

source "$CONFIG_DIR/colors.sh"

COLOR_FOCUSED="$TEXT_COLOR"
COLOR_VISIBLE="0xBB1F1F1F"
COLOR_ACTIVE="0x991F1F1F"
COLOR_EMPTY="0x441F1F1F"

WORKSPACE="${NAME##*.}"

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null | tr -d '[:space:]')
HAS_WINDOWS=$(aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l | tr -d ' ')

if [ "$WORKSPACE" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" icon.color=$COLOR_FOCUSED
elif [ "$HAS_WINDOWS" -gt 0 ]; then
  sketchybar --set "$NAME" icon.color=$COLOR_ACTIVE
else
  sketchybar --set "$NAME" icon.color=$COLOR_EMPTY
fi
