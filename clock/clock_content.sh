#!/bin/bash

while true; do
	# Get the time
	time=$(date +'%A, %I:%M %p')

	# Send content to clock_button.sh
	echo "^fg(#FF99A1)^i($HOME/.scripts/clock/icon.xbm)^fg(#E8DFD6)  $time"

	sleep 3
done
