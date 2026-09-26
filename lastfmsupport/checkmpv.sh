#!/bin/sh
# mpv-status: prints now-playing info for statusbar
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

# we get the album name by removing the song and artist. we then double check to make sure we didn't just
# get the song again. Because if there is no album, that seems to happen
album=$(echo "$full_path" | sed -e "s|${MUSIC_DIR}${artist_name}\/||" -e "s|\/.*${title}.*||")
# if we did just get the song again it will have the file extension at the end
# we use that to detect if the album exists
albumerror=$(echo "$album" | grep -o '\....$')

if expr "$albumerror" : '^\....$' > /dev/null; then

#echo "no album"
~/Documents/code/mpv-socket-follow-lastfm/scrobble.sh "$artist_name" "$title"
~/Documents/code/mpv-socket-follow-lastfm/updatenowplaying.sh "$artist_name" "$title"

else

~/Documents/code/mpv-socket-follow-lastfm/scrobble.sh "$artist_name" "$title" "$album"
~/Documents/code/mpv-socket-follow-lastfm/updatenowplaying.sh "$artist_name" "$title" "$album"

fi

echo "$artist_name" "$title" "$album" "$albumerror"


