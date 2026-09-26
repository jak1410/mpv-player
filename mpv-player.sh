#!/bin/sh

# THIS IS FOR PYWAL COLOR SCHEME
#. "${HOME}/.cache/wal/colors.sh"

# mpv-player: plays songs and albums from the $HOME/Music directory
MUSIC_DIR="$HOME/Music"
SOCKET="/tmp/mpvsocket"

if [ -n "$1" ]; then
    # sicne we have a file just play that and exit
    #pkill -f "mpv --no-terminal --vid=no --input-ipc-server=$SOCKET" 2>/dev/null
    pkill -f "input-ipc-server=$SOCKET" 2>/dev/null
    setsid mpv --no-terminal --vid=no --input-ipc-server="$SOCKET" "$1" &
    echo "no file found"
    exit 0
fi

# -sb "$color1" -sf "$color15" this is the default, I just changed it for the fall wallpaper
choice=$(
  {
    find "$MUSIC_DIR" -type d | sed "s|^$MUSIC_DIR/\?||" | sed '/^$/d' | sed 's|$|/|'
    find "$MUSIC_DIR" -type f \( \
        -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" \
        -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.opus" \
      \) | sed "s|^$MUSIC_DIR/||"
  } | sort | dmenu -b -i -c -bw 3 -l 20 -p "Play:" \
  -nb "$color0" -nf "$color15" \
  -sb "$color1" -sf "$color0"
)

[ -z "$choice" ] && exit 0

#pkill -f "mpv --no-terminal --input-ipc-server=$SOCKET" 2>/dev/null
pkill -f "input-ipc-server=$SOCKET" 2>/dev/null

if [ "${choice%/}" != "$choice" ]; then
  target="$MUSIC_DIR/${choice%/}"
  cd "$target" || exit 1
  # shellcheck disable=SC2086
  set -- *.mp3 *.flac *.wav *.m4a *.ogg *.opus
  # if you want music videos to work you can replace --vid=no with --audio-display=no
  exec mpv --no-terminal --vid=no --input-ipc-server="$SOCKET" "$@" &
else
  exec mpv --no-terminal --vid=no --input-ipc-server="$SOCKET" "$MUSIC_DIR/$choice" &
fi
