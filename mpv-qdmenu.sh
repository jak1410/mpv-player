#!/bin/sh

#THIS IS FOR PYWAL
#. "${HOME}/.cache/wal/colors.sh"

# mpv-qdmenu: plays songs and albums from the $HOME/Music directory
MUSIC_DIR="$HOME/Music"



choice=$(
  {
    find "$MUSIC_DIR" -type d | sed "s|^$MUSIC_DIR/\?||" | sed '/^$/d' | sed 's|$|/|'
    find "$MUSIC_DIR" -type f \( \
        -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" \
        -o -iname "*.m4a" -o -iname "*.ogg" -o -iname "*.opus" \
      \) | sed "s|^$MUSIC_DIR/||"
  } | sort | dmenu -b -i -c -bw 3 -l 20 -p "Add:" \
  -nb "$color0" -nf "$color15" \
  -sb "$color1" -sf "$color0"
)

[ -z "$choice" ] && exit 0


if [ "${choice%/}" != "$choice" ]; then
  target="$MUSIC_DIR/${choice%/}"
  cd "$target" || exit 1
  set --
  for f in *.mp3 *.flac *.wav *.m4a *.ogg *.opus; do
    [ -e "$f" ] && set -- "$@" "$target/$f"
  done
  [ "$#" -gt 0 ] && mpv-queue add "$@"
else
  mpv-queue add "$MUSIC_DIR/$choice"
fi
