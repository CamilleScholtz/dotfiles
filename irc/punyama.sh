#!/bin/bash

# Remove old text and kill old ii
pkill ii
sleep 0.5
rm -r $SCRIPTS/irc/text

# Lauch ii
ii -i $SCRIPTS/irc/text -s irc.freenode.net -n punyama &
sleep 0.5

# Connect to channel
echo "/j #doingitwell el_psy_congroo" > $SCRIPTS/irc/text/irc.freenode.net/in
sleep 0.5

# Make variables for in and out
in=$SCRIPTS/irc/text/irc.freenode.net/\#doingitwell/in
out=$SCRIPTS/irc/text/irc.freenode.net/\#doingitwell/out

# Say hi
echo "Reporting in~" > $in

tailf -n 1 $out | \
while read date time nick msg; do
	# If msg is by the system ignore it
	[[ $nick == '-!-' ]] && continue

	# Strip < and >, if msg is by ourself ignore it
	nick="${nick:1:-1}"
	[[ $nick == "punyama" ]] && continue

	# Commands

	# Check time
	if [[ $msg == .time ]]; then
		day=$(date +"%u")
		time=$(date +"%H%M")

		# TODO: Test this
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
		sum=$(echo $msg | cut -d " " -f 2-)

		echo $sum | bc -l > $in
	fi

	# Website stuff
	if [[ $msg =~ https?:// ]]; then
		url=$(echo $msg | grep -o -P "http(s?):\/\/[^ \"\(\)\<\>]*")

		# TODO: Why doesn't this need > $in?
		curl $url -s -o - | grep -i -P -o "(?<=<title>)(.*)(?=</title>)"
	fi

done > $in
