#!/bin/bash

while true; do
	# Get time
	time=$(date)

	# Check if it is weekend
	weekend=$(echo $time | grep "Fri\|Sat")

	# Check if it is bedtime
	bedtime=$(echo $time | grep "23:00:")

	if [[ -z $weekend -a -n $bedtime ]]; then
		# Combine all the variables into a single output and send this to notify.sh
		echo "Torrent finished: $@" > /home/onodera/.scripts/notify/text

		# Tell notify.sh that it needs to display a notication
		exec bash /home/onodera/.scripts/notify/notify.sh & disown

		
	fi

	sleep 30
done