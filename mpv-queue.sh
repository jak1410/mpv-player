#!/bin/sh
# mpv-queue: send a command to the running mpv instance for queueing another song
SOCKET="/tmp/mpvsocket"

[ -S "$SOCKET" ] || exit 0

case "$1" in
  add)
    if [ -z "$2" ]; then
        echo "Usage: mpv-queue add <file>..."
        exit 1
    fi

    shift
    for file in "$@"; do
        printf '%s\n' \
            '{ "command": ["loadfile", "'"$file"'", "append"] }' |
            socat - "$SOCKET"
    done
    ;;
# THIS IS ONLY COMPATIBLE WITH mpv 0.38.0 OR NEWER
#  add-next) 
#    if [ -z "$2" ]; then
#        echo "Usage: mpv-queue add-next <file>"
#        exit 1
#    fi
#    echo '{ "command": ["loadfile", "'"$2"'", "insert-next"] }' | socat - "$SOCKET"
#    ;;
  clear) echo '{ "command": ["playlist-clear"] }' | socat - "$SOCKET" ;;
# get-queue uses a lot of json query stuff that I don't understand... so, hopefully this never has to be debugged
  get-queue)
    response=$(printf '%s\n' \
        '{ "command": ["get_property", "playlist"] }' |
        socat -T 1 - "$SOCKET" |
        jq -r '
          .data as $pl
          | ($pl | map(.current == true) | index(true) // 0) as $i
          | $pl[$i:]
          | to_entries[]
          | (.value.filename | split("/")[-1] | sub("\\.[^.]+$"; "")) as $name
          | select($name != "*")
          | if .key == 0 then "▶ " + $name else "  " + $name end
        ')
    notify-send "mpv queue:" "$response"
    ;;

esac
