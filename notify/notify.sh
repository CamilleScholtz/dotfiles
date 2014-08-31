#!/bin/bash

# Get number of existing notifications
exist=$(pgrep -f "urxvt -name notification" | wc -w)

# Move existing notifications down
if [[ $exist -eq 1 ]]; then
	wmctrl -x -r notification0 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 2 ]]; then
	wmctrl -x -r  notification0 -e "0,-1,134,-1,-1"
	wmctrl -x -r  notification1 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 3 ]]; then
	wmctrl -x -r  notification0 -e "0,-1,184,-1,-1"
        wmctrl -x -r  notification1 -e "0,-1,134,-1,-1"
	wmctrl -x -r  notification2 -e "0,-1,84,-1,-1"
elif [[ $exist -eq 4 ]]; then
	# Check if notificationX has been killed already
	killed0=$(pgrep -f "urxvt -name notification0")
	killed1=$(pgrep -f "urxvt -name notification1")
	killed2=$(pgrep -f "urxvt -name notification2")
	killed3=$(pgrep -f "urxvt -name notification3")

	# Kill oldest notification because we don't want more than 4 notifications at once
	if [[ -n $killed0 ]]; then
		pkill -f "urxvt -name notification0"
		wmctrl -x -r  notification1 -e "0,-1,184,-1,-1"
        	wmctrl -x -r  notification2 -e "0,-1,134,-1,-1"
        	wmctrl -x -r  notification3 -e "0,-1,84,-1,-1"
	elif [[ -n $killed1 ]]; then
                pkill -f "urxvt -name notification1"
                wmctrl -x -r  notification2 -e "0,-1,184,-1,-1"
                wmctrl -x -r  notification3 -e "0,-1,134,-1,-1"
                wmctrl -x -r  notification4 -e "0,-1,84,-1,-1"
	elif [[ -n $killed2 ]]; then
                pkill -f "urxvt -name notification2"
                wmctrl -x -r  notification3 -e "0,-1,184,-1,-1"
                wmctrl -x -r  notification4 -e "0,-1,134,-1,-1"
                wmctrl -x -r  notification5 -e "0,-1,84,-1,-1"
	elif [[ -n $killed3 ]]; then
                pkill -f "urxvt -name notification3"
                wmctrl -x -r  notification4 -e "0,-1,184,-1,-1"
                wmctrl -x -r  notification5 -e "0,-1,134,-1,-1"
                wmctrl -x -r  notification6 -e "0,-1,84,-1,-1"
	fi	
fi

# Get the notification text
text=$(cat $HOME/.scripts/notify/text)

# Calculate the width of the spawned notification
count=$(echo $text | wc -m)
width=$(expr $(echo $text | pcregrep -o "[^\x00-\x7F]" | wc -m) / 3 + $count - 1)

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Spawn new notification, and kill it after 4 seconds
urxvt -name notification$exist -geometry "$width"x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
sleep 4
pkill -f "urxvt -name notification$exist"