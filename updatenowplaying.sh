#!/usr/bin/sh

APIKEYFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/apikey.txt"
APISECRETFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/secretkey.txt"
TOKENFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/token.txt"
SESSIONKEYFILE="/home/jak/Documents/code/mpv-socket-follow-lastfm/sessionkey.txt"

API_KEY=$(cat "$APIKEYFILE")
API_SECRET=$(cat "$APISECRETFILE")
TOKEN=$(cat "$TOKENFILE")
SESSION_KEY=$(cat "$SESSIONKEYFILE")

ARTIST="$1"
TRACK="$2"

# Params sorted alphabetically: album (skip if unused), api_key, artist, method, sk, track
SIG_STRING="api_key${API_KEY}artist${ARTIST}methodtrack.updateNowPlayingsk${SESSION_KEY}track${TRACK}${API_SECRET}"
API_SIG=$(echo -n "$SIG_STRING" | md5sum | cut -d' ' -f1)

curl -s \
  --data-urlencode "method=track.updateNowPlaying" \
  --data-urlencode "api_key=${API_KEY}" \
  --data-urlencode "artist=${ARTIST}" \
  --data-urlencode "track=${TRACK}" \
  --data-urlencode "sk=${SESSION_KEY}" \
  --data-urlencode "api_sig=${API_SIG}" \
  --data-urlencode "format=json" \
  "http://ws.audioscrobbler.com/2.0/" \
  | jq .
