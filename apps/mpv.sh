#!/bin/bash

# Check if the user entered a video
if [[ -z "$@" ]]; then
	echo "You must supply a video."
	exit
fi

# Check if url or video
url=$(echo "$@" | grep "http:\|https:")

# Check if the video contains an episode number
episode=$(echo "$@" | grep -o "E[0-9][0-9]" | tail -c 3)

if [[ -n $url ]]; then
	mpv --no-resume-playback --cookies --cookies-file $DOTFILES/mpv/cookie.txt $(youtube-dl -g --no-playlist --cookies $DOTFILES/mpv/cookie.txt $1) "$@"
elif [[ -n $episode ]]; then
	bash $SCRIPTS/apps/neet.sh -e "$*" $episode
	mpv "$@"
else
	mpv "$@"
fi
