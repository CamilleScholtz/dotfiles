#!/bin/bash

# TODO: Alphabeticaly sort list

# Define colors
white="\e[39m"
red="\e[35m"
brown="\e[33m"

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help)
			echo "-h         show help"
			echo "-l         list all escapism"
			echo "-L         list all currently watching escapism"
			echo "-t esc     toggle escapism active/watching status"
			echo "-T esc     toggle escapism watching/backlog status"
			echo "+ (esc)    +1 watched episode (if no esc is given the active esc will be used)"
			echo "- (esc)    -1 watched episode (if no esc is given the active esc will be used)"
			exit
			;;
		-l)
			# TODO: Add syntax highlighting same as vim
			# TODO: Replace vim with grep/cat
			vim $HOME/.scripts/neet/text.patch
			exit
			;;
		-L)
			# TODO: Add syntax highlighting same as vim
			cat $HOME/.scripts/neet/text.patch | grep "*\|+"
			exit
			;;
		-t)
			shift
			if [[ $# -ge 1 ]]; then
				# Fuzzy logic vars
				max=0
				answer=

				# Make newlines the only separator, also fixes other shit (need to read whole lines in the fuzzy logic for loop)
				IFS=$'\n'
				shopt -s nocasematch
				set -f

				# Fuzzy logic
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

				# Clean up answer
				case=$(echo $answer | cut -c 3-)

				# Get escapism status
				active=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep "*")
				watching=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep "+")


				# TODO: Make max 1 $active escapism
				if [[ -n $active ]]; then
					echo -e "${red}+ $case"
					sed -i "s|* $case|+ $case|g" $HOME/.scripts/neet/text.patch
					exit
				elif [[ -n $watching ]]; then
					echo -e "* $case"
					sed -i "s|+ $case|* $case|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "Escapism not found."
					exit
				fi
			else
				echo "No escapism provided."
				exit
			fi
			shift
			;;
		-T)
			shift
			if [[ $# -ge 1 ]]; then
				# Fuzzy logic vars
				max=0
				answer=

				# Make newlines the only separator, also fixes other shit (need to read whole lines in the fuzzy logic for loop)
				IFS=$'\n'
				shopt -s nocasematch
				set -f

				# Fuzzy logic
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

				# Clean up answer
				case=$(echo $answer | cut -c 3-)

				# Get escapism status
				watching=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep "+")
				backlog=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep "-")

				if [[ -n $watching ]]; then
					echo -e "${brown}- $case"
					sed -i "s|+ $case|- $case|g" $HOME/.scripts/neet/text.patch
					exit
				elif [[ -n $backlog ]]; then
					echo -e "${red}+ $case"
					sed -i "s|- $case|+ $case|g" $HOME/.scripts/neet/text.patch
					exit
				else
					echo "Escapism not found."
					exit
				fi
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
				# TODO: Fix 100+ episode total
				# Fuzzy logic vars
				max=0
				answer=

				# Make newlines the only separator, also fixes other shit (need to read whole lines in the fuzzy logic for loop)
				IFS=$'\n'
				shopt -s nocasematch
				set -f
 
				# Fuzzy logic
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

				# Clean up answer
				case=$(echo $answer | head -c -10 | cut -c 3-)

				# Get last watched episode and total episode count
				watching=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep -o "([0-9][0-9]" | tail -c 3)
				total=$(cat $HOME/.scripts/neet/text.patch | grep "$case" | grep -o "[0-9][0-9])" | head -c 2)

				# Increment watched count
				increment=$(expr $watching + 1)

				# Increase watched count
				# TODO: Add color to echo
				echo "Watching $case episode $increment."
				sed -i "s|* $case ($watching/$total)|* $case ($increment/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			else
				# TODO: Add an option so the user can set the episodes watched with numbers
				# TODO: Fix 100+ episode total
				# Get last watched episode and total episode count
				watching=$(cat $HOME/.scripts/neet/text.patch | grep "*" | grep -o "([0-9][0-9]" | tail -c 3)
				total=$(cat $HOME/.scripts/neet/text.patch | grep "*" | grep -o "[0-9][0-9])" | head -c 2)

				# Get escapism with correct capital letters
				case=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | head -c -10 | cut -c 3-)

				# Increment watched count
				increment=$(expr $watching + 1)

				# Increase watched count
				# TODO: Add color to echo
				echo "Watching $case episode $increment."
				sed -i "s|* $case ($watching/$total)|* $case ($increment/$total)|g" $HOME/.scripts/neet/text.patch
				exit
			fi
			shift
			;;
		-)
			# TODO: add (esc)
			# TODO: Add an option so the user can set the episodes watched with numbers
			# TODO: Fix 100+ episode total
			# Get last watched episode and total episode count
			watching=$(cat $HOME/.scripts/neet/text.patch | grep "*" | grep -o "([0-9][0-9]" | tail -c 3)
			total=$(cat $HOME/.scripts/neet/text.patch | grep "*" | grep -o "[0-9][0-9])" | head -c 2)

			# Get escapism with correct capital letters
			case=$(cat $HOME/.scripts/neet/text.patch | grep -i "*" | head -c -10 | cut -c 3-)

			# Increment watched count
			decrement=$(expr $watching - 1)

			# Increase watched count
			# TODO: Add color to echo
			echo "Watching $case episode $decrement."
			sed -i "s|* $case ($watching/$total)|* $case ($decrement/$total)|g" $HOME/.scripts/neet/text.patch
			exit
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
