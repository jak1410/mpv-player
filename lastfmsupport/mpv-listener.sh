#!/bin/sh
SOCKET="/tmp/mpvsocket"

while true; do
  { printf '%s\n' '{ "command": ["observe_property", 1, "media-title"] }'; tail -f /dev/null; } \
    | socat - "$SOCKET" \
    | while IFS= read -r line; do
        event=$(echo "$line" | jq -r '.event // empty')
        id=$(echo "$line" | jq -r '.id // empty')

        if [ "$event" = "property-change" ] && [ "$id" = "1" ]; then
            ~/Documents/code/mpv-socket-follow-lastfm/checkmpv.sh
        fi
      done
  sleep 1
done
