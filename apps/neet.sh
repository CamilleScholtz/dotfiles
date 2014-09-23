#!/bin/bash

# TODO: Alphabeticaly sort list
# TODO: Test if cap works
# TODO: Add 0 cap
# TODO: If statement [][][] doesn't work

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
	# TODO: check if 9 or 10 is correct
	casenoep=$(echo $case | head -c -9)

	# Case of active escapism
	# TODO: check if 9 or 10 is correct
	caseactive=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | head -c -9 | cut -c 3-)

	# Get escapism status
	active=$(cat $HOME/.scripts/neet/text.patch | grep "*")
	watching=$(cat $HOME/.scripts/neet/text.patch | grep "+")
	backlog=$(cat $HOME/.scripts/neet/text.patch | grep "-")

	# Get escapism case status
	watchingcase=$(echo $watching | grep "$case")
	backlogcase=$(echo $backlog | grep "$case")

	# Check if epsidode is < 10 or > 100
	# TODO: Optimize this
	lesslast=$(echo $case | grep -o "([0-9]/")
	morelast=$(echo $case | grep -o "([0-9][0-9][0-9]/")
	lesstotal=$(echo $case | grep -o "/[0-9])")
	moretotal=$(echo $case | grep -o "/[0-9][0-9][0-9])")
	lesslastactive=$(echo $active | grep -o "([0-9]/")
	morelastactive=$(echo $active | grep -o "([0-9][0-9][0-9]/")
	lesstotalactive=$(echo $active | grep -o "/[0-9])")
	moretotalactive=$(echo $active | grep -o "/[0-9][0-9][0-9])")

	# Get last watched episode and total episode count
	# TODO: Doesn't work
	if [[ -n $morelast ]]; then
		# TODO: make both 2/3 for consitency?
		last=$(echo $case | grep -o "([0-9][0-9][0-9]" | tail -c 3)
		lastactive=$(echo $active | grep -o "([0-9][0-9][0-9]" | tail -c 3)
	elif [[ -n $lesslast ]]; then
		# TODO: make both 2/3 for consitency?
		last=$(echo $case | grep -o "([0-9]" | tail -c 3)
		lastactive=$(echo $active | grep -o "([0-9]" | tail -c 3)
	else
		# TODO: make both 2/3 for consitency?
		last=$(echo $case | grep -o "([0-9][0-9]" | tail -c 3)
		lastactive=$(echo $active | grep -o "([0-9][0-9]" | tail -c 3)
	fi

	# TODO: Doesn't work
	if [[ -n $moretotal ]]; then
		# TODO: make both 2/3 for consitency?
		total=$(echo $case | grep -o "[0-9][0-9][0-9])" | head -c 2)
	elif [[ -n $lesstotal ]]; then
		# TODO: make both 2/3 for consitency?
		total=$(echo $case | grep -o "[0-9])" | head -c 2)
	else
		# TODO: make both 2/3 for consitency?
		total=$(echo $case | grep -o "[0-9][0-9])" | head -c 2)
	fi

		# TODO: Doesn't work
	if [[ -n $morelastactive ]]; then
		# TODO: make both 2/3 for consitency?
		lastactive=$(echo $active | grep -o "([0-9][0-9][0-9]" | tail -c 3)
	elif [[ -n $lesslastactive ]]; then
		# TODO: make both 2/3 for consitency?
		lastactive=$(echo $active | grep -o "([0-9]" | tail -c 3)
	else
		# TODO: make both 2/3 for consitency?
		lastactive=$(echo $active | grep -o "([0-9][0-9]" | tail -c 3)
	fi

	# TODO: Doesn't work
	if [[ -n $moretotalactive ]]; then
		# TODO: make both 2/3 for consitency?
		totalactive=$(echo $active | grep -o "[0-9][0-9][0-9])" | head -c 2)
	elif [[ -n $lesstotalactive ]]; then
		# TODO: make both 2/3 for consitency?
		totalactive=$(echo $active | grep -o "[0-9])" | head -c 2)
	else
		# TODO: make both 2/3 for consitency?
		totalactive=$(echo $active | grep -o "[0-9][0-9])" | head -c 2)
	fi

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
			if [[ $# -eq 1 ]]; then
				echo "Please provide escapism and watched episodes."
				exit
			elif [[ $2 -ge 2 ]]; then
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
					echo "❘ $casenoep ($end/$total)"
					exit
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
				# Set cap
				if [[ $last -le $total ]]; then
					# Increment watched count
					increment=$(expr $last + 1)

					# Echo and send to text
					echo "NEET changed:"
					echo -e "$red↑$white $casenoep ($increment/$total)"
					sed -i "s|$casenoep ($last/$total)|$casenoep ($increment/$total)|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "TODO: mesagge here"
					exit
				fi
			else
				# Set cap
				if [[ $last -le $total ]]; then
					# Increment watched count
					increment=$(expr $lastactive + 1)

					# Echo and send to text
					echo "NEET changed:"
					echo -e "$red↑$white $caseactive ($increment/$totalactive)"
					sed -i "s|$caseactive ($lastactive/$totalactive)|$caseactive ($increment/$totalactive)|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "TODO: mesagge here"
					exit
				fi
			fi
			shift
			;;
		-)
			shift
			if [[ $# -ge 1 ]]; then
				# Set cap
				if [[ $last -le $total ]]; then
					# Decrement watched count
					decrement=$(expr $last - 1)

					# Echo and send to text
					echo "NEET changed:"
					echo -e "$brown↓$white $casenoep ($decrement/$total)"
					sed -i "s|$casenoep ($last/$total)|$casenoep ($decrement/$total)|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "TODO: mesagge here"
					exit
				fi
			else
				# Set cap
				if [[ $last -le $total ]]; then
					# Decrement watched count
					decrement=$(expr $lastactive - 1)

					# Echo and send to text
					echo "NEET changed:"
					echo -e "$brown↓$white $caseactive ($decrement/$totalactive)"
					sed -i "s|* $caseactive ($lastactive/$totalactive)|* $caseactive ($decrement/$totalactive)|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "TODO: mesagge here"
					exit
				fi
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
