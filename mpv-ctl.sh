#!/bin/sh
# mpv-ctl: send a command to the running mpv instance
SOCKET="/tmp/mpvsocket"

[ -S "$SOCKET" ] || exit 0

case "$1" in
  toggle)  echo '{ "command": ["cycle", "pause"] }' | socat - "$SOCKET" ;;
  next)    echo '{ "command": ["playlist-next"] }'  | socat - "$SOCKET" ;;
  prev)    echo '{ "command": ["playlist-prev"] }'  | socat - "$SOCKET" ;;
  stop)    echo '{ "command": ["stop"] }'            | socat - "$SOCKET" ;;
  volup)   echo '{ "command": ["add", "volume", 5] }'  | socat - "$SOCKET" ;;
  voldown) echo '{ "command": ["add", "volume", -5] }' | socat - "$SOCKET" ;;

  # seeking
  seekfwd) echo '{ "command": ["seek", 5] }' | socat - "$SOCKET" ;;
  seekback)echo '{ "command": ["seek", -5] }' | socat - "$SOCKET" ;;

esac
