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

album=$(mpc -f "%album%")

# Spawn the album art, respawn album art if album changes
while true; do
	albumupdate=$(mpc -f "%album%")

	if [[ $album != $albumupdate ]]; then
		album=$(mpc -f "%album%")
		albumupdate=$album

		# Get the cover path
		path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

		feh -N -g 128x128+49+877 "$HOME/Music/$path/cover_popup.png" & disown
		echo yay
	fi
 
	sleep 1
done
