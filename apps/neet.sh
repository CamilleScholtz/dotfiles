#!/bin/bash

# TODO: Add sorting
# TODO: Fix fuzzy logic not working because episode numbers
# TODO: Automaticly replace escapism with drama/movie/etc.
# TODO: Add add option
# TODO: Add remove option
# TODO: Replace -w with +10/-10?
# TODO: Fix syntax
# TODO: Automaticly increase episode count with watch_later
# TODO: Make it look like pacaur

# Define colors
foreground="\e[0;39m"
blue="\e[1;34m"
brown="\e[1;33m"
green="\e[1;32m"
magenta="\e[1;35m"
maganta2="\e[1;31m"

# Fuzzy logic vars
max=0
answer=

# Make newlines the only separator (the fuzzy logic loop needs to read whole lines)
IFS=$'\n'
set -f

# Make bash case insensitive for fuzzy logic
shopt -s nocasematch

# Fuzzy logic
for line in $(cat $SCRIPTS/neet/text.patch); do
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

if [[ $# -le 1 ]]; then
	# Clean up answer (oh no actually don't, just use cat)
	escapism=$(cat $SCRIPTS/neet/text.patch | grep -i "*" | cut -c 3-)
else
	# Clean up answer
	escapism=$(echo $answer | cut -c 3-)
fi

# Escapism without episode info
escapismnoep=$(echo $escapism | cut -f 1 -d "(" | head -c -2)

# Escapism with only episode info
episode=$(echo $escapism | grep -o -P "(?<=\().*(?=\))")

# Get last watched and total episode info from $episode
last=$(echo $episode | cut -f 1 -d "/")
total=$(echo $episode | cut -f 2 -d "/")

# Get escapism status
active=$(cat $SCRIPTS/neet/text.patch | grep "*")
watching=$(cat $SCRIPTS/neet/text.patch | grep "+" | sort)
backlog=$(cat $SCRIPTS/neet/text.patch | grep "-" | sort)

# Check if the escapism is a drama or animu or... etc.
# TODO: FIx this
type=$(cat $SCRIPTS/neet/text.patch | sed "/$escapismnoep/d" | grep "#" | tail -n 1 | cut -c 3-)

if [[ $# -gt 0 ]]; then
	case $1 in
		-h|--help)
			echo "-h         show help"
			echo "-l         list all currently watching escapism"
			echo "-L         list all escapism"
			echo "-e         edit escapism list with $EDITOR"
			echo "-s* esc    set status of escapism"
			echo "  ^ b/w/a  backlog/watching/active"
			echo "-w         set watching episode number"
			echo "+ (esc)    increment watching episode number by 1"
			echo "- (esc)    decrement watching episode number by 1"
			exit
			;;
		-l)
			echo -e "$blue::$foreground Currently watching escapism..."
			echo "$active"
			echo -e "$magenta$watching"
			exit
			;;
		-L)
			echo -e "$blue::$foreground Currently watching escapism and backlog..."
			echo "$active"
			echo -e "$magenta$watching"
			echo -e "$brown$backlog"
			exit
			;;
		-e)
			vim $SCRIPTS/neet/text.patch
			exit
			;;
		-sb)
			shift
			if [[ $# -eq 1 ]]; then
				echo "neet.sh changed:"
				echo -e "$brown-$white $escapism"
				sed -i "s|. $escapism|- $escapism|g" $SCRIPTS/neet/text.patch
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
				echo -e "$magenta+$white $escapism"
				sed -i "s|. $escapism|+ $escapism|g" $SCRIPTS/neet/text.patch
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
					echo -e "$magenta+ $active"
					echo "* $escapism"
					sed -i "s|. $active|+ $active|g" $SCRIPTS/neet/text.patch
					sed -i "s|. $escapism|* $escapism|g" $SCRIPTS/neet/text.patch
					exit
				else
					echo "neet.sh changed:"
					echo "* $escapism"
					sed -i "s|. $escapism|* $escapism|g" $SCRIPTS/neet/text.patch
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
					echo -e "$magenta↑$white $escapismnoep ($end/$total)"
					exit
				elif [[ $end -lt $last ]]; then
					echo "neet.sh changed:"
					echo -e "$brown↓$white $escapismnoep ($end/$total)"
					exit
				else
					echo "neet.sh changed:"
					echo "‖ $escapismnoep ($end/$total)"
					exit
				fi
				sed -i "s|$escapismnoep ($last/$total)|$escapismnoep ($end/$total)|g" $SCRIPTS/neet/text.patch
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
				echo -e "$magenta↑$white $escapismnoep ($increment/$total)"
				sed -i "s|$escapismnoep ($last/$total)|$escapismnoep ($increment/$total)|g" $SCRIPTS/neet/text.patch
				exit
			else
				echo -e -n "$escapism completed! Would you like to remove this escapism? [${green}Yes$foreground/${magenta2}No$foreground] "
				while true; do
					read -r response
					if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
						sed -i "/$escapismnoep/d" $SCRIPTS/neet/text.patch
						exit
					elif [[ $response =~ ^([nN][oO]|[nN])$ ]]; then
						exit
					elif [[ -z $response ]]; then
						exit
					else
						echo -e -n "Sorry, response '$response' not understood. [${green}Yes$foreground/${magenta2}No$foreground] "
						continue
					fi
				done
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
				echo -e "$brown↓$white $escapismnoep ($decrement/$total)"
				sed -i "s|$escapismnoep ($last/$total)|$escapismnoep ($decrement/$total)|g" $SCRIPTS/neet/text.patch
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
fi

if [[ $# -eq 0 ]]; then
	# Add a 0 to numbers under 10, so 1 will become 01
	if [[ $last -eq 0 ]]; then
		last=01
	elif [[ $last -le 9 ]]; then
		for number in {1..9}; do
			if [[ $number -eq $last ]]; then
				last=0$number
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

		for words in "$escapismnoep"; do
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
	mpv --fullscreen --really-quiet "$HOME/Downloads/$answer/"*E$last*.*
fi
