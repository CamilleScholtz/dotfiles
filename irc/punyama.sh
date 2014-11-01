#!/bin/bash

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
			ii -i $SCRIPTS/irc/text -s irc.freenode.net -n punyama &
			sleep 0.5

			# Connect to channel
			#echo "/j #doingitwell el_psy_congroo" > $SCRIPTS/irc/text/irc.freenode.net/in
			echo "/j #punpuntest" > $SCRIPTS/irc/text/irc.freenode.net/in
			sleep 0.5
			;;
		esac
fi

# Make variables for in and out
#in=$SCRIPTS/irc/text/irc.freenode.net/\#doingitwell/in
#out=$SCRIPTS/irc/text/irc.freenode.net/\#doingitwell/out
in=$SCRIPTS/irc/text/irc.freenode.net/\#punpuntest/in
out=$SCRIPTS/irc/text/irc.freenode.net/\#punpuntest/out
save=$SCRIPTS/irc/save

# Say hi
echo "Reporting in~" > $in

tailf -n 1 $out | \
while read date time nick msg; do

	# Strip < and >, if msg is by ourself ignore it
	nick="${nick:1:-1}"
	[[ $nick == "punyama" ]] && continue

	if [[ $nick == ! ]]; then
		cat $save | grep $(echo $msg | cut -d "(" -f 1) | cut -d " " -f 2- > $in
	fi

	# Website stuff
	if [[ $msg =~ https?:// ]]; then
		url=$(echo $msg | grep -o -P "http(s?):\/\/[^ \"\(\)\<\>]*")

		# TODO: Why doesn't this need > $in?
		curl $url -s -o - | grep -i -P -o "(?<=<title>)(.*)(?=</title>)" > $in
	fi

	# Check if command
	if [[ $msg == .* ]]; then

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

		# Calculator
		if [[ $msg == .calc* ]]; then
			echo "$(echo $msg | cut -d " " -f 2-)" | bc -l > $in
		fi

		# Set intro message
		if [[ $msg == .intro* ]]; then
			if [[ -z $(cat $save | grep "onodera") ]]; then
				echo "$nick $(echo $msg | cut -d " " -f 2-)" >> $save
				echo "Intro set." > $in
			else
				sed -i "s/$nick */$nick $(echo $msg | cut -d " " -f 2-)/g" $save
				echo "Intro set." > $in
			fi
		fi

	fi
done > $in
