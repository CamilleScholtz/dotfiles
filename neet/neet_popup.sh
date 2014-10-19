#!/bin/bash

# Get the escapism name
case=$(cat $SCRIPTS/neet/text.patch | grep -i "*" | cut -c 3-| cut -f 1 -d "(" | head -c -2)

# Get the currenly watching episode number
episode=$(cat $SCRIPTS/neet/text.patch | grep -i "*" | grep -o -P "(?<=\().*(?=\))" | cut -f 1 -d "/")

# Add a 0 to numbers under 10, so 1 will become 01
if [[ $episode -eq 0 ]]; then
	episode=01
elif [[ $episode -le 9 ]]; then
	for number in {1..9}; do
		if [[ $number -eq $episode ]]; then
			episode=0$number
		fi
	done
fi

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
mpv --fullscreen "$HOME/Downloads/$answer/"*E$episode*.mkv
