#!/bin/bash

# TODO: Fix cursor thingy
# TODO: Show an arrow

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Kill popup if popup is already open
exist=$(pgrep -f "urxvt -name music_popup")
if [[ -n $exist ]]; then
	pkill -f -o "bash $HOME/.scripts/music/music_popup.sh"
	pkill -f -o "feh --title music_art"*
	pkill -f -o "urxvt -name music_popup"*
	exit
fi

# Spawn the popup
urxvt -name music_popup -sl 0 -geometry 50x9 -internalBorder 13 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e bash $HOME/.scripts/music/music_popup_content.sh & disown

# Get the cover path
path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

# Spawn the album art
feh --title music_art -N -g 128x128+52+880 "$HOME/Music/$path/cover_popup.png" & disown

current=$(mpc -f "%album%" | head -n 1 | cut -c -22)

# Respawn album art if album changes
while true; do
	new=$(mpc -f "%album%" | head -n 1 | cut -c -22)

	if [[ $current != $new ]]; then
		current=$(mpc -f "%album%" | head -n 1 | cut -c -22)
		new=$album

		# Kill the old album art
		pkill -f -o "feh --title music_art"*

		# Get the updated cover path
		path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

		# Respawn new album art
		feh --title music_art -N -g 128x128+52+880 "$HOME/Music/$path/cover_popup.png" & disown
	fi
 
	sleep 0.5
done
