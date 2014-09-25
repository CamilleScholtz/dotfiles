#!/bin/bash

# TODO: Fix cursor thingy
# TODO: Show an arrow

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Kill popup if popup is already open
exist=$(pgrep -f "urxvt -name music_popup")
if [[ -n $exist ]]; then
	pkill -n "feh"
	pkill -fn "urxvt -name music_popup"*
	exit
fi

# Spawn the popup
urxvt -name music_popup -geometry 50x9 -internalBorder 13 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch -n 1 -t -c bash $HOME/.scripts/music/music_popup_content.sh & disown

# Get the cover path
path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

# Spawn the album art
feh -N -g 128x128+52+880 "$HOME/Music/$path/cover_popup.png" & disown

album=$(mpc -f "%album%" | head -n 1 | cut -c -22)

# Respawn album art if album changes
while true; do
	albumupdate=$(mpc -f "%album%" | head -n 1 | cut -c -22)

	echo $album
	echo $albumupdate

	if [[ $albumupdate  != $album ]]; then
		album=$(mpc -f "%album%" | head -n 1 | cut -c -22)
		albumupdate=$album

		# Kill the old album art
		pkill -n "feh"

		# Get the updated cover path
		path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

		# Respawn new album art
		feh -N -g 128x128+52+880 "$HOME/Music/$path/cover_popup.png" & disown
		echo changed
	fi
 
	sleep 1
done
