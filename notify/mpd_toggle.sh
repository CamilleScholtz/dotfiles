#!/bin/bash

# Toggle play/pause, also check for errors
toggle=$(mpc toggle | grep -o "ERROR")

# Send "in use" notification and kills script if error is found
if [[ -n $toggle ]]; then
        echo "Audio device currently in use"  > /home/onodera/.scripts/notify/text
	exec bash /home/onodera/.scripts/notify/notify.sh & disown
	exit 0
fi

# Get current playing song from MPD
current=$(mpc current)

# Get song status from MPD
status=$(mpc | grep -o "playing\|paused")

# Combine all the variables into a single output and send this to notify.sh
if [[ $status == playing ]]; then
	echo "Song resumed: $current" > /home/onodera/.scripts/notify/text
else
	echo "Song paused: $current" > /home/onodera/.scripts/notify/text
fi

# Tell notify.sh that it needs to display a notication
exec bash /home/onodera/.scripts/notify/notify.sh & disown