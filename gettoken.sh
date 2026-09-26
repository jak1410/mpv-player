#!/usr/bin/env bash
set -euo pipefail

API_KEY=""
API_SECRET=""

# Build the signature for auth.getToken
# Params (sorted alphabetically): api_key, method
SIG_STRING="api_key${API_KEY}methodauth.gettoken${API_SECRET}"
API_SIG=$(echo -n "$SIG_STRING" | md5sum | cut -d' ' -f1)

curl -s \
  --get "http://ws.audioscrobbler.com/2.0/" \
  --data-urlencode "method=auth.getToken" \
  --data-urlencode "api_key=${API_KEY}" \
  --data-urlencode "api_sig=${API_SIG}" \
  --data-urlencode "format=json" \
  | jq .
