#!/bin/bash

white=$(cat $HOME/.Xresources | grep foreground | tail -c 8)
red=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

while true; do
	# Get current escapism
	current=$(cat $HOME/.scripts/neet/text.patch | grep "*" | cut -c 3-)

	# Send content to neet_button.sh
	echo "^fg($white)$current ^fg($red)^i($HOME/.scripts/neet/icon.xbm)"

	sleep 30
done
