#!/bin/bash

while true; do
	# Get current escapism
	current=$(cat $HOME/.scripts/neet/text.patch | grep "*" | cut -c 3-)

	# Get last watched episode
	#last=$(cat $HOME/.zsh_history | grep -o "E[0-9][0-9]" | tail -n 1 | tail -c 3)

	# Get directory of current escapism
	#max=0
	#answer=
	#for directory in $HOME/Downloads/*; do
	#	match=0
	#	for words in $current; do
	#		[[ $directory = @("$words"|"$words"[![:alpha:]]*|*[![:alpha:]]"$words"|*[![:alpha:]]"$words"[![:alpha:]]*) ]] && ((match++))
	#	done
	#
	#	if [[ match -gt $max ]]; then
	#		max=$match
	#		answer=$directory
	#	fi
	#done

	# Get all episodes
	#all=$(ls "$answer" | grep .mkv | wc -l)

	# Send content to escapism_button.sh
	echo "^fg(#E8DFD6)$current  ^fg(#FF99A1)^i($HOME/.scripts/neet/icon.xbm)"

	sleep 30
done
