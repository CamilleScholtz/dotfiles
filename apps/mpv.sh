#!/bin/bash

url=$(echo $@ | grep "http:\|https:")

# Check if the user entered a video
if [[ -z $@ ]]; then
	echo "You must supply a video."
	exit 0
fi

# Launch mpv with youtube-dl if url is given
if [[ -n $url ]]; then
	mpv -cookies -cookies-file $HOME/.mpv/cookie.txt $(youtube-dl -g  --cookies $HOME/.mpv/cookie.txt $1) "$@"
else
	mpv "$@"
fi