#!/bin/bash

# TODO: Alphabeticaly sort list
# TODO: Add another echo above echo

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
		# TODO: does match neet a $ here?
		if [[ match -gt $max ]]; then
			max=$match
			answer=$line
		fi
	done

	# Make bash case sensitive again
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

	# TODO: Fix 100+ episode total/watching
	# TODO: Fix 10- episode total/watching
	# Get last watched episode and total episode count
	last=$(echo $case | grep -o "([0-9][0-9]" | tail -c 3)
	total=$(echo $case | grep -o "[0-9][0-9])" | head -c 2)

	# TODO: Fix 100+ episode total/watching
	# TODO: Fix 10- episode total/watching
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
					echo -e "$red+ $active"
					echo "* $case"
					sed -i "s|. $active|+ $active|g" $HOME/.scripts/neet/text.patch
					sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
				else
					echo "* $case"
					sed -i "s|. $case|* $case|g" $HOME/.scripts/neet/text.patch
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
			if [[ $# -eq 1 ]]; then
				echo "Please provide escapism and watched episodes."
				exit
			elif [[ $2 -ge 2 ]]; then
				# Get last parameter (aka episode number)
				for end; do true; done

				# Echo and send to text
				if [[ $end -gt $last ]]; then
					echo -e "$red↑$white $casenoep ($end/$total)"
				elif [[ $end -lt $last ]]; then
					echo -e "$brown↓$white $casenoep ($end/$total)"
				else
					# TODO: Replace space with something interesting
					echo "  $casenoep ($end/$total)"
				fi
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
				# Decrement watched count
				decrement=$(expr $last - 1)

				# Echo and send to text
				echo -e "$brown↓$white $casenoep ($decrement/$total)"
				sed -i "s|$casenoep ($last/$total)|$casenoep ($decrement/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				# Decrement watched count
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
