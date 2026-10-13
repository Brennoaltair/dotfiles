#!/bin/bash

STATE=$(osascript -e 'if application "Spotify" is running then tell application "Spotify" to player state as string' 2>/dev/null)

if [ "$STATE" = "playing" ] || [ "$STATE" = "paused" ]; then
  ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track as string' 2>/dev/null)
  TRACK=$(osascript -e 'tell application "Spotify" to name of current track as string' 2>/dev/null)
  LABEL="$ARTIST — $TRACK"
  [ ${#LABEL} -gt 45 ] && LABEL="${LABEL:0:42}..."
  sketchybar --set spotify label="$LABEL" drawing=on
else
  sketchybar --set spotify drawing=off
fi
