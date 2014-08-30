#!/bin/bash

while true; do
	# Get items
	todo=$(cat /home/onodera/.scripts/reminder/text | sed '/^\s*$/d' | wc -l)

	# Send content to reminder_button.sh
	echo "^fg(#E8DFD6)$todo reminders  ^fg(#FF99A1)^i(/home/onodera/.scripts/reminder/icon.xbm)"

	sleep 15
done