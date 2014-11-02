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

			# Lauch ii
			ii -i $SCRIPTS/irc/text -s $server -n punyama &
			sleep 0.5

			# Connect to channel
			echo "/j #$channel $password" > $SCRIPTS/irc/text/$server/in
			sleep 0.5
			;;
	esac
fi

# Make variables for in and out.
in=$SCRIPTS/irc/text/$server/\#$channel/in
out=$SCRIPTS/irc/text/$server/\#$channel/out

# Say hi
echo "Reporting in~" > $in

tailf -n 1 $out | \
while read date time nick msg; do

	# Strip < and >, if msg is by ourself ignore it
	nick="${nick:1:-1}"
	[[ $nick == "punyama" ]] && continue

	# Join stuff
	if [[ $nick == ! && -n $(tail -n 1 $out | grep "has joined") ]]; then
		fixednick=$(echo "$msg" | cut -d "(" -f 1)

		# Intro
		cat $SCRIPTS/irc/intro.txt | grep $realnick | cut -d " " -f 2- > $in
		# Message
		# TODO: Grep returns a non-critical error here
		if [[ -n $(cat $SCRIPTS/irc/msg.txt | grep $fixednick | cut -d " " -f 2-) ]]; then
			if [[ $fixednick == onodera ]]; then
				swapednick=Vista-Narvas
			elif [[ $fixednick == Vista-Narvas ]]; then
				swapednick=onodera
			fi

			echo "$swapednick has left a message for you: $(cat $SCRIPTS/irc/msg.txt | grep $fixednick | cut -d " " -f 2-)" > $in
			sed -i "/$fixednick .*/d" $SCRIPTS/irc/msg.txt
		fi
	fi

	# Website stuff
	# TODO: filter png/jpg thingy
	if [[ $msg =~ https?:// && -z $(echo "$msg" | grep -i ".*[a-z0-9].png") && -z $(echo "$msg" | grep -i ".*[a-z0-9].jpg") ]]; then
		url=$(echo "$msg" | grep -o -P "http(s?):\/\/[^ \"\(\)\<\>]*")
		title=$(curl -s "$url" | grep -i -P -o "(?<=<title>)(.*)(?=</title>)")

		# Check if url is NSFW
		if [[ -n $(echo "$msg $title" | grep -i "porn\|penis\|sexy\|gay\|anal\|pussy\|/b/\|nsfw\|gore") ]]; then
			echo -e "(${red}NSFW$foreground) $title" > $in
		else
			echo "$title" > $in
		fi
	fi

	# Check if command
	if [[ $msg == "."* ]]; then

		# Display help
		if [[ $msg == ".help" ]]; then
			echo -e ".about .calc .count .grep .intro .kill .msg .ping .reload .time .quote($red!$foreground)" > $in
		fi

		# About message
		if [[ $msg == ".about" ]]; then
			uptime=$(ps -p $$ -o etime= | cut -c 7-)
			hostname=$(hostname)
			distro=$(cat /etc/*-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

			echo "punyama version 0.30, alive for $uptime~" > $in
			echo "Hosted by $USER@$hostname, running $distro~" > $in
			echo "https://github.com/onodera-punpun/scripts/tree/master/irc"
		fi

		# Calculator
		if [[ $msg == ".calc "* ]]; then
			echo "$(echo $msg | cut -d " " -f 2-)" | bc -l > $in
		fi

		# Calculator
		if [[ $msg == ".calc" ]]; then
			echo "Please enter a calculation~" > $in
		fi

		# Count words
		if [[ $msg == ".count "* ]]; then
			if [[ $(echo $msg | cut -d " " -f 2-) == onodera ]]; then
				results=$(cat $out | grep "<onodera>")
				echo "onodera has spoken $(echo "$results" | wc -l) times~" > $in
			elif [[ $(echo $msg | cut -d " " -f 2-) == Vista-Narvas ]]; then
				results=$(cat $out | grep "<Vista-Narvas>")
				echo "Vista-Narvas has spoken $(echo "$results" | wc -l) times~" > $in
			else
				results=$(cat $out | grep -v "<punyama>" | grep -v "\-!\-" | grep "$(echo "$msg" | cut -d " " -f 2-)" | cut -d " " -f 3-)
				echo "This word has been used $(echo "$results" | wc -l) times~" > $in
			fi
		fi

		# Grep error
		if [[ $msg == ".count" ]]; then
			echo "Please specify at least one search term~" > $in
		fi

		# Grep through logs
		# TODO: Rice this with color.
		if [[ $msg == ".grep "* ]]; then
			results=$(cat $out | grep -v "<punyama>" | grep -v "\-!\-" | grep -v "> .grep" | grep "$(echo "$msg" | cut -d " " -f 2-)" | cut -d " " -f 3-)
			count=$(echo "$results" | wc -l)

			if [[ $count -ge 5 ]]; then
				echo "$results" | tail -n 4 > $in
				echo "$results" > $SCRIPTS/irc/grep.txt

				upload=$(curl --silent -sf -F files[]="@$SCRIPTS/irc/grep.txt" "http://pomf.se/upload.php")
				pomffile=$(echo "$upload" | grep -E -o '"url":"[A-Za-z0-9]+.txt",' | sed 's/"url":"//;s/",//')
				url=http://a.pomf.se/$pomffile

				echo "$(expr $count - 4) more results: $url" > $in
			elif [[ -z $results ]]; then
				echo "No results~" > $in
			else
				echo "$results" > $in
			fi
		fi

		# Grep error
		if [[ $msg == ".grep" ]]; then
			echo "Please specify at least one search term~" > $in
		fi

		# Set intro message
		if [[ $msg == ".intro "* ]]; then
			if [[ -z $(cat $SCRIPTS/irc/intro.txt | grep "$nick") ]]; then
				echo "$nick $(echo $msg | cut -d " " -f 2-)" >> $SCRIPTS/irc/intro.txt
				echo "Intro set~" > $in
			else
				sed -i "s/$nick .*/$nick $(echo $msg | cut -d " " -f 2-)/g" $SCRIPTS/irc/intro.txt
				echo "Intro set~" > $in
			fi
		fi

		# Get intro message
		if [[ $msg == ".intro" ]]; then
			echo "Your intro is: $(cat $SCRIPTS/irc/intro.txt | grep $nick | cut -d " " -f 2-)" > $in
		fi

		# Kill punyama ;_;
		if [[ $msg == ".kill" ]]; then
			if [[ $nick == onodera ]]; then
				echo "Commiting sudoku~" > $in
				pkill ii
				exit
			else
				echo "Sorry, only onodera can kill me~" > $in
			fi
		fi

		# Leave message
		if [[ $msg == ".msg "* ]]; then
			if [[ $nick == onodera ]]; then
			swapednick=Vista-Narvas
			elif [[ $nick == Vista-Narvas ]]; then
			swapednick=onodera
			fi

			if [[ -z $(cat $SCRIPTS/irc/msg.txt | grep "$swapednick") ]]; then
				echo "$swapednick $(echo $msg | cut -d " " -f 2-)" >> $SCRIPTS/irc/msg.txt
				echo "Message left~" > $in
			else
				sed -i "s/$swapednick .*/$swapednick $(echo $msg | cut -d " " -f 2-)/g" $SCRIPTS/irc/msg.txt
				echo "Message left~" > $in
			fi
		fi

		# Get message
		if [[ $msg == ".msg" ]]; then
			# Message
			# TODO: Grep returns a non-critical error here
			if [[ -n $(cat $SCRIPTS/irc/msg.txt | grep $nick | cut -d " " -f 2-) ]]; then
				if [[ $nick == onodera ]]; then
					swapednick=Vista-Narvas
				elif [[ $nick == Vista-Narvas ]]; then
					swapednick=onodera
				fi

				echo "$swapednick has left a message for you: $(cat $SCRIPTS/irc/msg.txt | grep $fixednick | cut -d " " -f 2-)" > $in
				sed -i "/$nick .*/d" $SCRIPTS/irc/msg.txt
			else
				echo "Sorry, you don't have any messages~" > $in
			fi
		fi

		# ping
		if [[ $msg == ".ping" ]]; then
			echo "pong~" > $in
		fi

		# Reload punyama
		if [[ $msg == ".reload" ]]; then
			bash $SCRIPTS/irc/punyama.sh & disown
			exit
		fi

		# Check time
		if [[ $msg == ".time" ]]; then
			day=$(date +"%u")
			time=$(date +"%H%M")

			# TODO: Test this, make vista and onodera versions
			if [[ $day -le 5 && $time -le 1730 ]]; then
				left=$(expr 1730 - $time)

				if [[ $nick == onodera ]]; then
					date +"The time is %I:%M %p, $left hours left~" > $in
				elif [[ $nick == Vista-Narvas ]]; then
					date +"The time is %I:%M %p, $left hours left~" > $in
				fi
			else
				date +"The time is %I:%M %p~" > $in
			fi
		fi

		# Post random quote
		# TODO: Fix this
		#if [[ $msg == ".quote "* ]]; then
		#	cat $out | grep "$(echo $msg | cut -d " " -f 2-)" | shuf -n 1 | cut -d " " -f 3- > $in
		#fi

	fi

done > $in
