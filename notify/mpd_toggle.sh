#!/bin/bash

# Toggle play/pause
mpc toggle

# Get current playing song from MPD
current=$(mpc current)

# Get song status from MPD
status=$(mpc | grep -o "playing\|paused")

# Combine all the variables into a single output and send this to notify.sh
if [[ $status == playing ]]; then
	echo Song resumed: $current > /home/kamiru/.scripts/notify/text
else
	echo Song paused: $current > /home/kamiru/.scripts/notify/text
fi

# Tell notify.sh that it needs to display a notication
exec sh /home/kamiru/.scripts/notify/notify.sh
