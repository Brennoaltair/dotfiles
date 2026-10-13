#!/bin/bash

if [ "$SENDER" = "mouse.clicked" ]; then
  open "x-apple.systempreferences:com.apple.Sound-Settings.extension"
  exit 0
fi

VOLUME=$(osascript -e "output volume of (get volume settings)" 2>/dev/null)
[ -z "$VOLUME" ] && exit 0

sketchybar --set "$NAME" icon="VOL ${VOLUME}%"
