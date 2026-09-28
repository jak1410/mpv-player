#!/bin/bash

~/Documents/code/mpv-socket-follow-lastfm/mpv-listener.sh > /dev/null 2>&1 &
~/Documents/code/mpv-socket-follow-lastfm/autoupdateplaying.sh > /dev/null 2>&1 &
disown
