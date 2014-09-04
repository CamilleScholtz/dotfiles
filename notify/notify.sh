#!/bin/bash

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Get the notification text
text=$(cat $HOME/.scripts/notify/text)

# Calculate the width of the spawned notification
count=$(echo $text | wc -m)
width=$(expr $(echo $text | pcregrep -o "[^\x00-\x7F]" | wc -m) / 3 + $count - 1)

# Get number of existing notifications
exist=$(pgrep -f "urxvt -name notification" | wc -w)

# Spawn notifications
if [[ $exist -eq 1 ]]; then
	wmctrl -x -r notification0 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 2 ]]; then
	wmctrl -x -r notification0 -e "0,-1,134,-1,-1"
	wmctrl -x -r notification1 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 3 ]]; then
	wmctrl -x -r notification0 -e "0,-1,184,-1,-1"
	wmctrl -x -r notification1 -e "0,-1,134,-1,-1"
	wmctrl -x -r notification2 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 4 ]]; then
	last=$(ps -p $(pgrep -f -o "urxvt -name notification") -o args | grep -o "[0-9]" | head -1)

	pkill -f "urxvt -name notification$last"

	plus1=$(expr $last + 1)
	plus2=$(expr $last + 2)
	plus3=$(expr $last + 3)
	plus4=$(expr $last + 4)

	wmctrl -x -r notification$plus1 -e "0,-1,184,-1,-1"
	wmctrl -x -r notification$plus2 -e "0,-1,134,-1,-1"
	wmctrl -x -r notification$plus3 -e "0,-1,84,-1,-1"

	urxvt -name notification$plus4 -geometry "$width"x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
	sleep 5
	pkill -f "urxvt -name notification$plus4"
	exit
fi 

urxvt -name notification$exist -geometry "$width"x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
sleep 5
pkill -f "urxvt -name notification$exist"
