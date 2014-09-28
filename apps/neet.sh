#!/bin/bash

# TODO: Fix "
# TODO: Add sorting
# TODO: Add comment in -l and -L
# TODO: Fix fuzzy logic not working because episode numbers
# TODO: Add -e
# TODO: Add "want to remove this escapism" to cap
# TODO: Automaticly replace escapism with drama/movie/etc.

# Define colors
foreground="\e[0;39m"
brown="\e[1;33m"
red="\e[1;35m"

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

		for words in "$@"; do
			[[ $line = @("$words"|"$words"[![:alpha:]]*|*[![:alpha:]]"$words"|*[![:alpha:]]"$words"[![:alpha:]]*) ]] && ((match++))
		done

		# And make newlines the only seperator again
		IFS=$'\n'

		# Check which line has the most matches
		if [[ $match -gt $max ]]; then
			max=$match
			answer=$line
		fi
	done

	# Restore all these bash things to the default value
	IFS=$' \t\n'
	set +f
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

	# Get escapism status
	# TODO: Add comment in -l and -L
	active=$(cat $HOME/.scripts/neet/text.patch | grep "*")
	watching=$(cat $HOME/.scripts/neet/text.patch | grep "+" | sort)
	backlog=$(cat $HOME/.scripts/neet/text.patch | grep "-" | sort)

	case $1 in
		-h|--help)
			echo "-h         show help"
			echo "-l         list all currently watching escapism"
			echo "-L         list all escapism"
			echo "-e         edit escapism list with $EDITOR"
			echo "-s* esc    set status of escapism"
			echo "  ^ b/w/a  backlog/watching/active"
			echo "-w         set watching episode #"
			echo "+ (esc)    increment watching episode #"
			echo "- (esc)    decrement watching episode #"
			exit
			;;
		-l)
			echo "$active"
			echo -e "$red$watching"
			exit
			;;
		-L)
			echo "$active"
			echo -e "$red$watching"
			echo -e "$brown$backlog"
			exit
			;;
		-sb)
			shift
			if [[ $# -eq 1 ]]; then
				echo "neet.sh changed:"
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
				echo "neet.sh changed:"
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
					echo "neet.sh changed:"
					echo -e "$red+ $active"
					echo "* $case"
					sed -i "s|. $active|+ $active|g" $HOME/.scripts/neet/text.patch
					sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "neet.sh changed:"
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
		-w)
			shift
			if [[ $2 -ge 2 ]]; then
				# Get last parameter (aka episode number)
				for end; do true; done

				# Echo and send to text.patch
				if [[ $end -gt $last ]]; then
					echo "neet.sh changed:"
					echo -e "$red↑$white $casenoep ($end/$total)"
					exit
				elif [[ $end -lt $last ]]; then
					echo "neet.sh changed:"
					echo -e "$brown↓$white $casenoep ($end/$total)"
					exit
				else
					echo "neet.sh changed:"
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
				echo "neet.sh changed:"
				echo -e "$red↑$white $casenoep ($increment/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($increment/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				echo "Escapism completed!"
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
				echo "neet.sh changed:"
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
