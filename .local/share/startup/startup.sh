#!/usr/bin/env sh

STARTUP_SONG="$HOME/.local/share/startup/startup.flac"
if [ -f "$STARTUP_SONG" ]; then
  flac123 "$STARTUP_SONG" >/dev/null &
fi
