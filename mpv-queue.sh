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

    mpv_get() {
      echo "{\"command\":[\"get_property\",\"$1\"]}" | socat - "$SOCKET" | jq -r '.data'
    }

    path=$(mpv_get path)

    # mpv reports relative paths as given, so resolve them
    case "$path" in
      /*) ;;
      *) path="$(mpv_get working-directory)/$path" ;;
    esac

    cover=/tmp/mpv_cover.png
    if ! ffmpeg -y -loglevel error -i "$path" -an -frames:v 1 \
         -vf scale=128:-1 "$cover" 2>/dev/null; then
      cover="$(dirname "$path")/.cover.png"   # fallback if no embedded art
    fi


    # the -a music is a dunstrc thing I have. you can remove it but it makes the image size inconsistent without it
    # if you want to actually use it. add this to your dunstrc (~/.config/dunst/dunstrc)
    #
    #[mycustom]
    #  appname = music
    #  max_icon_size = 64
    #  frame_color = "#88c0d0"
    #  timeout = 8
    notify-send -a music -i "$cover" "mpv queue:" "$response"
    ;;

esac
