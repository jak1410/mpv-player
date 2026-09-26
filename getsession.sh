#!/usr/bin/env bash
set -euo pipefail

API_KEY=""
API_SECRET=""
TOKEN=""

# Params sorted alphabetically: api_key, method, token
SIG_STRING="api_key${API_KEY}methodauth.getSessiontoken${TOKEN}${API_SECRET}"
API_SIG=$(echo -n "$SIG_STRING" | md5sum | cut -d' ' -f1)

curl -s \
  --get "http://ws.audioscrobbler.com/2.0/" \
  --data-urlencode "method=auth.getSession" \
  --data-urlencode "api_key=${API_KEY}" \
  --data-urlencode "token=${TOKEN}" \
  --data-urlencode "api_sig=${API_SIG}" \
  --data-urlencode "format=json" \
  | jq .
