#!/bin/bash

# TODO: Alphabeticaly sort list

# Define colors
white="\e[39m"
red="\e[1;35m"
brown="\e[1;33m"

while [[ $# -gt 0 ]]; do
	# Fuzzy logic vars
	max=0
	answer=

	# Make newlines the only separator (the fuzzy logic loop needs to read whole lines)
	IFS=$'\n'
	set -f

	# Make bash case insensitive for fuzzy logic
	shopt -s nocasematch

	# Fuzzy logic
	for line in $(cat $HOME/.scripts/neet/text.patch); do
		match=0

		# Set default seperator value again (for the next loop to work)
		IFS=$' \t\n'

		for words in $@; do
			[[ $line = @("$words"|"$words"[![:alpha:]]*|*[![:alpha:]]"$words"|*[![:alpha:]]"$words"[![:alpha:]]*) ]] && ((match++))
		done

		# And make newkines the only seperator again
		IFS=$'\n'

		# Check which line has the most matches
		if [[ $match -gt $max ]]; then
			max=$match
			answer=$line
		fi
	done

	# Make bash case sensitive again
	shopt -u nocasematch

	if [[ $# -eq 1 ]]; then
		# Clean up answer (oh no actually don't, just use cat)
		case=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | cut -c 3-)
	else
		# Clean up answer
		case=$(echo $answer | cut -c 3-)
	fi

	# Case without episode info
	casenoep=$(echo $case | cut -f 1 -d "(" | head -c -2)

	# Case with only episode info
	episode=$(echo $case | grep -o -P "(?<=\().*(?=\))")

	# Get last watched and total episode info from $episode
	last=$(echo $episode | cut -f 1 -d "/")
	total=$(echo $episode | cut -f 2 -d "/")


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
			echo "- (esc)    decrement watching episode #"
			exit
			;;
		-l)
			# Get escapism status
			active=$(cat $HOME/.scripts/neet/text.patch | grep "*")
			watching=$(cat $HOME/.scripts/neet/text.patch | grep "+")

			echo "$active"
			echo -e "$red$watching"
			exit
			;;
		-L)
			# Get escapism status
			active=$(cat $HOME/.scripts/neet/text.patch | grep "*")
			watching=$(cat $HOME/.scripts/neet/text.patch | grep "+")
			backlog=$(cat $HOME/.scripts/neet/text.patch | grep "-")


			echo "$active"
			echo -e "$red$watching"
			echo -e "$brown$backlog"
			exit
			;;
		-sb)
			shift
			if [[ $# -eq 1 ]]; then
				echo "NEET changed:"
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
				echo "NEET changed:"
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
				count=$(echo $active | wc -w)
				if [[ $count -ge 2 ]]; then
					echo "NEET changed:"
					echo -e "$red+ $active"
					echo "* $case"
					sed -i "s|. $active|+ $active|g" $HOME/.scripts/neet/text.patch
					sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "NEET changed:"
					echo "* $case"
					sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
					exit
				fi
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		-e)
			shift
			# TODO: Fix wrong fuzzy results because numbers
			if [[ $2 -ge 2 ]]; then
				# Get last parameter (aka episode number)
				for end; do true; done

				# Echo and send to text.patch
				if [[ $end -gt $last ]]; then
					echo "NEET changed:"
					echo -e "$red↑$white $casenoep ($end/$total)"
					exit
				elif [[ $end -lt $last ]]; then
					echo "NEET changed:"
					echo -e "$brown↓$white $casenoep ($end/$total)"
					exit
				else
					echo "NEET changed:"
					echo "‖ $casenoep ($end/$total)"
					exit
				fi
				sed -i "s|$casenoep ($last/$total)|$casenoep ($end/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			elif [[ $# -eq 1 ]]; then
				echo "Please provide escapism and watched episodes."
				exit
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		+)
			shift
			# Set cap
			if [[ $last -lt $total ]]; then
				# Increment watched count
				increment=$(expr $last + 1)

				# Echo and send to text
				echo "NEET changed:"
				echo -e "$red↑$white $casenoep ($increment/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($increment/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "Completed escapism!"
				exit
			fi
			shift
			;;
		-)
			shift
			# Set cap
			if [[ $last -gt 0 ]]; then
				# Decrement watched count
				decrement=$(expr $last - 1)

				# Echo and send to text
				echo "NEET changed:"
				echo -e "$brown↓$white $casenoep ($decrement/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($decrement/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "Can't go lower than 0!"
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
