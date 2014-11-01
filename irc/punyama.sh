#!/bin/bash

# Define colors
foreground="\x03"
red="\x0305"

# Define default values
server=irc.freenode.net
channel=doingitwell
password=el_psy_congroo

if [[ $# -ge 1 ]]; then
	case "$1" in
		-h|--help)
			echo "-h         help"
			echo "-r         hard reload"
			exit
			;;
		-r)
			# Kill old ii
			pkill ii
			sleep 0.5
			rm -r $SCRIPTS/irc/text

			# Lauch ii
			ii -i $SCRIPTS/irc/text -s $server -n punyama &
			sleep 0.5

			# Connect to channel
			echo "/j #$channel $password" > $SCRIPTS/irc/text/$server/in
			sleep 0.5
			;;
	esac
fi

# Make variables for in, out and save
in=$SCRIPTS/irc/text/$server/\#$channel/in
out=$SCRIPTS/irc/text/$server/\#$channel/out
save=$SCRIPTS/irc/save

# Say hi
echo "Reporting in~" > $in

tailf -n 1 $out | \
while read date time nick msg; do

	# Strip < and >, if msg is by ourself ignore it
	nick="${nick:1:-1}"
	[[ $nick == "punyama" ]] && continue

	# Intro stuff
	if [[ $nick == ! && -n $(tail -n 1 $out | grep "has joined") ]]; then
		cat $save | grep $(echo $msg | cut -d "(" -f 1) | cut -d " " -f 2- > $in
	fi

	# Website stuff
	# TODO: Add filter for jpg and other files
	if [[ $msg =~ https?:// && -z $(echo $msg | grep -i ".*[a-z0-9].png") ]]; then
		url=$(echo $msg | grep -o -P "http(s?):\/\/[^ \"\(\)\<\>]*")
		title=$(curl -s $url | grep -i -P -o "(?<=<title>)(.*)(?=</title>)")

		if [[ -n $(echo $msg $title | grep -i "porn\|penis\|sexy\|gay\|anal\|pussy\|/b/\|nsfw") ]]; then
			echo -e "(${red}NSFW$foreground) $title" > $in
		else
			echo "$title" > $in
		fi
	fi

	# Check if command
	if [[ $msg == .* ]]; then

		# Display help
		if [[ $msg == .help ]]; then
			echo "Commands with (!) don't work correctly yet."
			echo ".about .calc .grep(!) .intro .kill .ping .reload .time .quote(!)" > $in
		fi

		# About message
		if [[ $msg == .about ]]; then
			uptime=$(ps -p $$ -o etime= | cut -c 7-)
			hostname=$(hostname)
			distro=$(cat /etc/*-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

			echo "punyama version 0.19, alive for $uptime." > $in
			echo "Hosted by $USER@$hostname, running $distro." > $in
			echo "https://github.com/onodera-punpun/scripts/tree/master/irc"
		fi

		# Calculator
		if [[ $msg == .calc* ]]; then
			echo "$(echo $msg | cut -d " " -f 2-)" | bc -l > $in
		fi

		# Grep through logs
		# TODO: Rice this.
		if [[ $msg == .grep* ]]; then
			cat $out | grep "$(echo $msg | cut -d " " -f 2-)" | tail -n 5 | head -n -1 > $in
		fi

		# Set intro message
		if [[ $msg == .intro* ]]; then
			if [[ -z $(cat $save | grep "onodera") ]]; then
				echo "$nick $(echo $msg | cut -d " " -f 2-)" >> $save
				echo "Intro set." > $in
			else
				sed -i "s/$nick .*/$nick $(echo $msg | cut -d " " -f 2-)/g" $save
				echo "Intro set." > $in
			fi
		fi

		# Kill punyama
		if [[ $msg == .kill ]]; then
			if [[ $nick == onodera ]]; then
				echo "Commiting sudoku." > $in
				pkill $SCRIPTS/irc/punyama.sh
				pkill ii
			else
				echo "Sorry, only onodera can kill me." > $in
			fi
		fi

		# ping
		if [[ $msg == .ping ]]; then
			echo "pong" > $in
		fi

		# Reload punyama
		if [[ $msg == .reload ]]; then
			pkill $SCRIPTS/irc/punyama.sh
			bash $SCRIPTS/irc/punyama.sh
		fi

		# Check time
		if [[ $msg == .time ]]; then
			day=$(date +"%u")
			time=$(date +"%H%M")

			# TODO: Test this, make vista and onodera versions
			if [[ $day -le 5 && $time -le 1730 ]]; then
				left=$(expr 1730 - $time)

				if [[ $nick == onodera ]]; then
					date +"The time is %I:%M %p, $left hours left." > $in
				elif [[ $nick == Vista-Narvas ]]; then
					date +"The time is %I:%M %p, $left hours left." > $in
				fi
			else
				date +"The time is %I:%M %p." > $in
			fi
		fi

		# Post random quote
		# TODO: Fix this
		#if [[ $msg == .quote* ]]; then
		#	cat $out | grep "$(echo $msg | cut -d " " -f 2-)" | shuf -n 1 | cut -d " " -f 3- > $in
		#fi

	fi
done > $in
