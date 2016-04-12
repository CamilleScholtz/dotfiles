#!/bin/bash

# Kill popup if popup is already open
exist="$(pgrep -f "bar -g 286x152+"*)"
if [[ -n "$exist" ]]; then
	pkill -f "bar -g 263x14+"
	pkill -f "bar -g 286x152+"
	pkill -f "feh --title music_art"
	pkill -f "feh --title music_arrow"
	pkill -f "bash $HOME/.bar/music/music_popup_"
	pkill -f "bash $HOME/.bar/music/music_popup"
	exit
fi

# Spawn the popup
bash "$HOME/.bar/music/music_popup_background.sh" & disown
bash "$HOME/.bar/music/music_popup_album.sh" & disown
bash "$HOME/.bar/music/music_popup_artist.sh" & disown
bash "$HOME/.bar/music/music_popup_title.sh" & disown
bash "$HOME/.bar/music/music_popup_progress.sh" & disown

# Spawn an arrow
# TODO: Optimize this, lol
feh --title music_arrow -N --zoom fill -g 18x1+52+1020 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 16x1+53+1021 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 14x1+54+1022 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 12x1+55+1023 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 10x1+56+1024 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 8x1+57+1025 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 6x1+58+1026 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 4x1+59+1027 "$HOME/.bar/music/music_arrow.png" & disown
feh --title music_arrow -N --zoom fill -g 2x1+60+1028 "$HOME/.bar/music/music_arrow.png" & disown

# Get the cover path
path="$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")"

# Spawn the album art
feh --title music_art -N -g 152x152+40+868 "$HOME/music/$path/cover_popup.png" & disown

current="$(mpc -f "%album%" | head -n 1 | cut -c -22)"

# Respawn album art if album changes
while true; do
	new="$(mpc -f "%album%" | head -n 1 | cut -c -22)"

	if [[ "$current" != "$new" ]]; then
		current="$(mpc -f "%album%" | head -n 1 | cut -c -22)"
		new="$album"

		# Kill the old album art
		pkill -f "feh --title music_art"

		# Get the updated cover path
		path="$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")"

		# Respawn new album art
		feh --title music_art -N -g 152x152+40+868 "$HOME/music/$path/cover_popup.png" & disown
	fi

	sleep 0.2
done
