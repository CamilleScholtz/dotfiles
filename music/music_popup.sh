#!/bin/bash

# TODO: Fix cursor thingy
# TODO: Fix arrow getting killed on album change

# Get color from .Xresources
color=$(cat $DOTFILES/Xresources | grep background | tail -c 8)

# Kill popup if popup is already open
exist=$(pgrep -f "urxvt -name music_popup")
if [[ -n $exist ]]; then
	pkill -f "feh --title music_art"
	pkill -f "feh --title music_arrow"
	pkill -f "urxvt -name music_popup"
	pkill -f "bash $SCRIPTS/music/music_popup.sh"
	exit
fi

# Spawn the popup
urxvt -name music_popup -sl 0 -geometry 50x9 -internalBorder 13 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e bash $SCRIPTS/music/music_popup_content.sh & disown

# Spawn an arrow
# TODO: Optimize this, lol
feh --title music_arrow -N --zoom fill -g 18x1+52+1019 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 16x1+53+1020 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 14x1+54+1021 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 12x1+55+1022 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 10x1+56+1023 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 8x1+57+1024 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 6x1+58+1025 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 4x1+59+1026 "$SCRIPTS/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 2x1+60+1027 "$SCRIPTS/music/music_arrow.png" & disown

# Get the cover path
path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

# Spawn the album art
feh --title music_art -N -g 128x128+52+878 "$HOME/Music/$path/cover_popup.png" & disown

current=$(mpc -f "%album%" | head -n 1 | cut -c -22)

# Respawn album art if album changes
while true; do
	new=$(mpc -f "%album%" | head -n 1 | cut -c -22)

	if [[ $current != $new ]]; then
		current=$(mpc -f "%album%" | head -n 1 | cut -c -22)
		new=$album

		# Kill the old album art
		pkill -f "feh --title music_art"

		# Get the updated cover path
		path=$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")

		# Respawn new album art
		feh --title music_art -N -g 128x128+52+878 "$HOME/Music/$path/cover_popup.png" & disown
	fi
 
	sleep 0.5
done
