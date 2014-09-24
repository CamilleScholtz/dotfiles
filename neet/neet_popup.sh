#!/bin/bash

case=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | cut -c 3-| cut -f 1 -d "(" | head -c -2)
episode=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | grep -o -P "(?<=\().*(?=\))" | cut -f 1 -d "/")

# Fuzzy logic vars
max=0
answer=

# Make newlines the only separator (the fuzzy logic loop needs to read whole lines)
IFS=$'\n'
set -f

# Make bash case insensitive for fuzzy logic
shopt -s nocasematch

# Fuzzy logic
for directory in $(ls $HOME/Downloads); do
	match=0

	# Set default seperator value again (for the next loop to work)
	IFS=$' \t\n'

	for words in "$case"; do
		[[ $directory = @("$words"|"$words"[![:alpha:]]*|*[![:alpha:]]"$words"|*[![:alpha:]]"$words"[![:alpha:]]*) ]] && ((match++))
	done

	# And make newlines the only seperator again
	IFS=$'\n'

	# Check which line has the most matches
	if [[ $match -gt $max ]]; then
		max=$match
		answer=$directory
	fi
done

# Restore all these bash things to the default value
IFS=$' \t\n'
set +f
shopt -u nocasematch

# Launch mpv
mpv "$HOME/Downloads/$answer/"*E$episode*.mkv
