#!/bin/bash

# TODO: Fix fucking stacking errors

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Get the notification text
text=$(cat $HOME/.scripts/notify/text)

# Calculate the width of the spawned notification
count=$(echo $text | wc -m)
width=$(expr $(echo $text | pcregrep -o "[^\x00-\x7F]" | wc -m) / 3 + $count - 1)

# Get number of existing notifications
exist=$(pgrep -f "urxvt -name notification" | wc -w)

# Get oldest notification numbers
last0=$(ps -p $(pgrep -f -o "urxvt -name notification") -o args 2>/dev/null | grep -o "[0-9]" | head -1)
last1=$(expr $last0 + 1)
last2=$(expr $last0 + 2)
last3=$(expr $last0 + 3)
last4=$(expr $last0 + 4)

# Move old notifications
if [[ $exist -eq 1 ]]; then
	wmctrl -x -r notification$last0 -e "0,-1,96,-1,-1"
elif [[ $exist -eq 2 ]]; then
	wmctrl -x -r notification$last0 -e "0,-1,146,-1,-1"
	wmctrl -x -r notification$last1 -e "0,-1,96,-1,-1"
elif [[ $exist -eq 3 ]]; then
	wmctrl -x -r notification$last0 -e "0,-1,196,-1,-1"
	wmctrl -x -r notification$last1 -e "0,-1,146,-1,-1"
	wmctrl -x -r notification$last2 -e "0,-1,96,-1,-1"
elif [[ $exist -eq 4 ]]; then
	pkill -f "urxvt -name notification$last0"

	wmctrl -x -r notification$last1 -e "0,-1,196,-1,-1"
	wmctrl -x -r notification$last2 -e "0,-1,146,-1,-1"
	wmctrl -x -r notification$last3 -e "0,-1,96,-1,-1"

	urxvt -name notification$last4 -geometry "$width"x1 -internalBorder 13 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
	sleep 5
	pkill -f "urxvt -name notification$last4"
	exit
fi 

urxvt -name notification$exist -geometry "$width"x1 -internalBorder 13 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
sleep 5
pkill -f "urxvt -name notification$exist"
