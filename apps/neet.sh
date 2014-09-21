#!/bin/bash

# TODO: Alphabeticaly sort list

# Define colors
white="\e[39m"
red="\e[35m"
brown="\e[33m"

while [[ $# -gt 0 ]]; do
	# Fuzzy logic vars
	max=0
	answer=

	# Make newlines the only separator (need to read whole lines in the fuzzy logic for loop)
	IFS=$'\n'
	set -f

	# Fuzzy logic
	shopt -s nocasematch
	for line in $(cat $HOME/.scripts/neet/text.patch); do
				match=0

		IFS=$' \t\n'
		for words in $@; do
			[[ $line = @("$words"|"$words"[![:alpha:]]*|*[![:alpha:]]"$words"|*[![:alpha:]]"$words"[![:alpha:]]*) ]] && ((match++))
		done

		if [[ match -gt $max ]]; then
			max=$match
			answer=$line
		fi
	done
	shopt -u nocasematch

	# Clean up answer
	case=$(echo $answer | cut -c 3-)

	# Case without episode info
	casenoep=$(echo $case | head -c -10)

	# Case of active escapism
	caseactive=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | head -c -10 | cut -c 3-)

	# Get escapism status
	active=$(cat $HOME/.scripts/neet/text.patch | grep "*")
	watching=$(cat $HOME/.scripts/neet/text.patch | grep "+")
	backlog=$(cat $HOME/.scripts/neet/text.patch | grep "-")

	# Get escapism case status
	watchingcase=$(echo $watching | grep "$case")
	backlogcase=$(echo $backlog | grep "$case")

	# Get last watched episode and total episode count
	last=$(echo $case | grep -o "([0-9][0-9]" | tail -c 3)
	total=$(echo $case | grep -o "[0-9][0-9])" | head -c 2)

	# Last/total episode count of active escapism
	lastactive=$(echo $active | grep -o "([0-9][0-9]" | tail -c 3)
	totalactive=$(echo $active | grep -o "[0-9][0-9])" | head -c 2)

	case "$1" in
		-h|--help)
			# TODO: Clean this
			echo "-h         show help"
			echo "-l         list all currently watching escapism"
			echo "-L         list all escapism"
			echo "-s* esc    set status of escapism"
			echo "  ^ b/w/a  backlog/watching/active"
			echo "-e         set watching episode #"
			echo "+ (esc)    increment watching episode #"
			echo "- (esc)    decrenebt watching episode #"
			exit
			;;
		-l)
			# TODO: Add syntax highlighting same as vim
			echo "$active"
			echo "$watching"
			exit
			;;
		-L)
			# TODO: Add syntax highlighting same as vim
			echo "$active"
			echo "$watching"
			echo "$backlog"
			exit
			;;
		-sb)
			shift
			if [[ $# -eq 1 ]]; then
				# TODO: Make max 1 $active escapism
				echo -e "$brown-$white $case"
				sed -i "s|. $case|- $case|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		-sw)
			shift
			if [[ $# -eq 1 ]]; then
				# TODO: Make max 1 $active escapism
				echo -e "$red+$white $case"
				sed -i "s|. $case|+ $case|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		-sa)
			shift
			if [[ $# -eq 1 ]]; then
				# TODO: Make max 1 $active escapism
				echo "* $case"
				sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		-e)
			shift
			if [[ $# -eq 1 ]]; then
				echo "Please provide escapism and watched episodes."
				exit
			elif [[ $2 -ge 2 ]]; then
				# Get last parameter (aka episode number)
				for end; do true; done

				# Echo and send to text
				# TODO: add up/down arrow support
				echo -e "$red↑$white $casenoep ($end/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($end/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		+)
			shift
			if [[ $# -ge 1 ]]; then
				# TODO: Add an option so the user can set the episodes watched with numbers
				# TODO: Fix 100+ episode total/watching
				# TODO: Fix 10- episode total/watching
				# Increment watched count
				increment=$(expr $last + 1)

				# Echo and send to text
				echo -e "$red↑$white $casenoep ($increment/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($increment/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				# Increment watched count
				increment=$(expr $lastactive + 1)

				# Echo and send to text
				echo -e "$red↑$white $caseactive ($increment/$totalactive)"
				sed -i "s|$caseactive ($lastactive/$totalactive)|$caseactive ($increment/$totalactive)|g" $HOME/.scripts/neet/text.patch
				exit
			fi
			shift
			;;
		-)
			shift
			if [[ $# -ge 1 ]]; then
				# TODO: Add an option so the user can set the episodes watched with numbers
				# TODO: Fix 100+ episode total/watching
				# TODO: Fix 10- episode total/watching
				# Increment watched count
				decrement=$(expr $last - 1)

				# Echo and send to text
				echo -e "$brown↓$white $casenoep ($decrement/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($decrement/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				# Increment watched count
				decrement=$(expr $lastactive - 1)

				# Echo and send to text
				echo -e "$brown↓$white $caseactive ($decrement/$totalactive)"
				sed -i "s|* $caseactive ($lastactive/$totalactive)|* $caseactive ($decrement/$totalactive)|g" $HOME/.scripts/neet/text.patch
				exit
			fi
			shift
			;;
		*)
			echo "Invalid option, use -h for help."
			exit
			;;
	esac
done

if [[ $# -eq 0 ]]; then
	echo "No option provided, use -h for help."
fi
