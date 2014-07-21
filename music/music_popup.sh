#!/bin/bash

# TODO: Fix albumart not changing
#	Fix urxvt not closing after song change
#	Fix cursor thingy
#	Show an arrow
#	Use a failsave close method
#	Disable spawning more than one popup

# Get the cover path name
path=$(mpc -f "%file%" | head -n 1 | cut -f1-2 -d "/")

# Get color from .Xresources
color=$(cat /home/onodera/.Xresources | grep background | tail -c 8)

# Spawn the popup
urxvt -name music_popup -geometry 50x9 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch -t -c bash /home/onodera/.scripts/music/music_popup_content.sh & disown

# Wait a bit and spawn the album art, it we don't wait the popup will overlap the album art
sleep 0.1
exec feh -g 128x128+49+877 "/home/onodera/Music/$path/cover_popup.png"