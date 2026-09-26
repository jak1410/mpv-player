#!/bin/sh
# checkmpv: used for the lastfm module, to find the info on the song currently playing
SOCKET="/tmp/mpvsocket"
MUSIC_DIR="/home/$USER/Music/"

query() {
  echo "{ \"command\": [\"get_property\", \"$1\"] }" | socat - "$SOCKET" 2>/dev/null | jq -r '.data'
}


if [ ! -S "$SOCKET" ]; then
  exit 0
fi

title=$(query "media-title")

if [ -z "$title" ] || [ "$title" = "null" ]; then
  exit 0
fi

full_path=$(find /home/jak/Music/ -type f -name "$title")

title=$(echo "$title" | sed -E -e 's/\.(mp3|flac|wav|m4a|ogg|opus)$//i' -e 's/^[0-9][0-9] - //')  # we were using I for case insensitivity, but that's a GNU-ism. so we use i now (yes I know i isn't possix either)


artist_name=$(echo "$full_path" | sed -e "s|${MUSIC_DIR}||" -e 's/\/.*$//')

echo "$artist_name" "$title"
~/Documents/code/mpv-socket-follow-lastfm/scrobble.sh "$artist_name" "$title"
~/Documents/code/mpv-socket-follow-lastfm/updatenowplaying.sh "$artist_name" "$title"
