#!/bin/bash

while true; do
	# Get current escapism
	current=$(cat $HOME/.scripts/neet/text.patch | grep "*" | cut -c 3-)

	# Send content to neet_button.sh
	echo "^fg(#E8DFD6)$current ^fg(#FF99A1)^i($HOME/.scripts/neet/icon.xbm)"

	sleep 30
done
