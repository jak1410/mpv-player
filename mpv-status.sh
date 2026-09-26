#!/bin/sh
# mpv-status: prints now-playing info for statusbar
SOCKET="/tmp/mpvsocket"

query() {
  echo "{ \"command\": [\"get_property\", \"$1\"] }" | socat - "$SOCKET" 2>/dev/null | jq -r '.data'
}

fmt_time() {
  t=$1
  if [ -z "$t" ] || [ "$t" = "null" ]; then
    printf '%s' '-'
    return
  fi

  t=${t%.*}
  printf '%d:%02d' $((t / 60)) $((t % 60))
}

if [ ! -S "$SOCKET" ]; then
  echo "🎵: ..."
  exit 0
fi

title=$(query "media-title")

if [ -z "$title" ] || [ "$title" = "null" ]; then
  echo "🎵: ..."
  exit 0
fi

title=$(echo "$title" | sed -E -e 's/\.(mp3|flac|wav|m4a|ogg|opus)$//i' -e 's/^[0-9][0-9] - //')  # we were using I for case insensitivity, but that's a GNU-ism. so we use i now

pos=$(query "time-pos")
dur=$(query "duration")

echo "🎵: $title [$(fmt_time "$pos")/$(fmt_time "$dur")]"
