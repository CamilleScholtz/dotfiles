#!/bin/bash

# Check if the user entered a video
if [[ -z "$@" ]]; then
	echo "You must supply a video."
	exit
fi

# Check if url or video
url=$(echo "$@" | grep "http:\|https:")

if [[ -n $url ]]; then
	mpv --no-resume-playback --cookies --cookies-file $HOME/.mpv/cookie.txt $(youtube-dl -g --no-playlist --cookies $HOME/.mpv/cookie.txt $1) "$@"
else
	mpv "$@"
fi
