#!/bin/bash

white=$(cat $HOME/.Xresources | grep foreground | tail -c 8)
red=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

while true; do
	# Get the time
	time=$(date +'%A, %I:%M %p')

	# Send content to clock_button.sh
	echo "^fg($red)^i($HOME/.scripts/clock/icon.xbm)^fg($white)  $time"

	sleep 3
done
