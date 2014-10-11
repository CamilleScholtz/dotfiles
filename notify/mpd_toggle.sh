#!/bin/bash

# Toggle play/pause, also check for errors
toggle=$(mpc toggle | grep -o "ERROR")

# Send "in use" notification and kills script if error is found
if [[ -n $toggle ]]; then
        echo "Audio device currently in use" > $SCRIPTS/notify/text
	exec bash $SCRIPTS/notify/notify.sh & disown
	exit
fi

# Get current playing song from MPD
current=$(mpc current)

# Get song status from MPD
status=$(mpc | grep -o "playing\|paused")

# Combine all the variables into a single output and send this to notify.sh
if [[ $status == playing ]]; then
	echo "Song resumed: $current" > $SCRIPTS/notify/text
else
	echo "Song paused: $current" > $SCRIPTS/notify/text
fi

# Tell notify.sh that it needs to display a notication
exec bash $SCRIPTS/notify/notify.sh & disown
