#!/usr/bin/env bash
set -euo pipefail

APIKEYFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/apikey.txt"
APISECRETFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/secretkey.txt"
SESSIONKEYFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/sessionkey.txt"

API_KEY=$(cat "$APIKEYFILE")
API_SECRET=$(cat "$APISECRETFILE")
SESSION_KEY=$(cat "$SESSIONKEYFILE")

ARTIST="$1"
TRACK="$2"
ALBUM="${3:-}"

TIMESTAMP=$(date +%s)  # normally this is "when the track started," captured earlier

# Params sorted alphabetically: album, api_key, artist, method, sk, timestamp, track
if [ -n "$ALBUM" ]; then
  SIG_STRING="album${ALBUM}api_key${API_KEY}artist${ARTIST}methodtrack.scrobblesk${SESSION_KEY}timestamp${TIMESTAMP}track${TRACK}${API_SECRET}"
else
  SIG_STRING="api_key${API_KEY}artist${ARTIST}methodtrack.scrobblesk${SESSION_KEY}timestamp${TIMESTAMP}track${TRACK}${API_SECRET}"
fi
API_SIG=$(echo -n "$SIG_STRING" | md5sum | cut -d' ' -f1)

if [ -n "$ALBUM" ]; then
  curl -s \
    --data-urlencode "method=track.scrobble" \
    --data-urlencode "api_key=${API_KEY}" \
    --data-urlencode "artist=${ARTIST}" \
    --data-urlencode "track=${TRACK}" \
    --data-urlencode "album=${ALBUM}" \
    --data-urlencode "timestamp=${TIMESTAMP}" \
    --data-urlencode "sk=${SESSION_KEY}" \
    --data-urlencode "api_sig=${API_SIG}" \
    --data-urlencode "format=json" \
    "http://ws.audioscrobbler.com/2.0/" \
    | jq .
else
  curl -s \
    --data-urlencode "method=track.scrobble" \
    --data-urlencode "api_key=${API_KEY}" \
    --data-urlencode "artist=${ARTIST}" \
    --data-urlencode "track=${TRACK}" \
    --data-urlencode "timestamp=${TIMESTAMP}" \
    --data-urlencode "sk=${SESSION_KEY}" \
    --data-urlencode "api_sig=${API_SIG}" \
    --data-urlencode "format=json" \
    "http://ws.audioscrobbler.com/2.0/" \
    | jq .
fi
