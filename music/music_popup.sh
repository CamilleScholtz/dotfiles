#!/bin/bash

# TODO: Fix albumart not changing
#	Fix urxvt not closing after song change
#	Fix cursor thingy
#	Show an arrow

# Get the cover path name
path=$(mpc -f "%file%" | head -n 1 | cut -f1-2 -d "/")

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Kill popup if popup is already open
exist=$(pgrep -f "urxvt -name music_popup")
if [[ -n $exist ]]; then
	pkill -n "feh"
	pkill -fn "urxvt -name music_popup"*
	exit 0
fi

# Spawn the popup
urxvt -name music_popup -geometry 50x9 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch -t -c bash $HOME/.scripts/music/music_popup_content.sh & disown

# Wait a bit and spawn the album art, it we don't wait the popup will overlap the album art
sleep 0.1
exec feh -g 128x128+49+877 "/home/onodera/Music/$path/cover_popup.png" & disown