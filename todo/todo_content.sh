#!/bin/bash

while true; do
	# Get items
	todo=$(cat /home/onodera/.scripts/todo/text | sed '/^\s*$/d' | wc -l)

	# Send content to todo_button.sh
	echo "^fg(#E8DFD6)$todo reminders  ^fg(#FF99A1)^i(/home/onodera/.scripts/todo/icon.xbm)"

	sleep 9
done
