#!/bin/bash

# Toggle play/pause, also check for errors
toggle=$(mpc toggle | grep -o "ERROR")

# Send "in use" notification and kills script if error is found
if [[ -n $toggle ]]; then
        echo "Audio device currently in use"  > $HOME/.scripts/notify/text
	exec bash $HOME/.scripts/notify/notify.sh & disown
	exit 0
fi

# Get current playing song from MPD
current=$(mpc current)

# Get song status from MPD
status=$(mpc | grep -o "playing\|paused")

# Combine all the variables into a single output and send this to notify.sh
if [[ $status == playing ]]; then
	echo "Song resumed: $current" > $HOME/.scripts/notify/text
else
	echo "Song paused: $current" > $HOME/.scripts/notify/text
fi

# Tell notify.sh that it needs to display a notication
exec bash $HOME/.scripts/notify/notify.sh & disown