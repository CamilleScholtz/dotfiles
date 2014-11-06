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
			# TODO: Fix this, als change -r?
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

	# Fix nicks
	shopt -s nocasematch
	if [[ $nick == "Vista-Narvas"* || $nick == "Vista_Narvas"* ]]; then
		nick=Vista-Narvas
	elif [[ $nick == "onodera"* || $nick == "kamiru"* || $nick == "camille"* ]]; then
		nick=onodera
	fi
	shopt -u nocasematch

	# Join stuff
	if [[ $nick == ! && -n $(tail -n 1 $out | grep "has joined") ]]; then
		fixednick=$(echo "$msg" | cut -d "(" -f 1)
		if [[ $fixednick == Vista_Narvas ]]; then
			fixednick=Vista-Narvas
		fi

		# Intro
		cat $SCRIPTS/irc/intro.txt | grep $fixednick | cut -d " " -f 2- > $in
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

	# Afk stuff
	if [[ -n $(cat $SCRIPTS/irc/afk.txt | grep $nick) ]]; then
		echo "$nick is no longer afk~"
		sed -i "/$nick .*/d" $SCRIPTS/irc/afk.txt
	fi

	# Website stuff
	# TODO: filter png/jpg thingy
	if [[ $msg =~ https?:// && -z $(echo "$msg" | grep -i -s ".*[a-z0-9].png") && -z $(echo "$msg" | grep -i -s ".*[a-z0-9].jpg") ]]; then
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
			echo -e ".about .afk($red!$foreground) .calc($red!$foreground) .count .date .day .fortune .grep($red!$foreground) .intro .kill .msg .ping .random($red!$foreground) .reload($red!$foreground) .time($red!$foreground)" > $in

		# About message
		elif [[ $msg == ".about" ]]; then
			version=$(cat $SCRIPTS/irc/punyama.sh | sum | cut -d " " -f 1)
			uptime=$(ps -p $$ -o etime= | cut -c 7-)
			hostname=$(hostname)
			distro=$(cat /etc/*-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

			echo "punyama version $version, alive for $uptime~" > $in
			echo "Hosted by $USER@$hostname, running $distro~" > $in
			echo "https://github.com/onodera-punpun/scripts/tree/master/irc"

		# Set afk message
		elif [[ $msg == ".afk "* ]]; then
			if [[ -z $(cat $SCRIPTS/irc/afk.txt | grep "$nick") ]]; then
				echo "$nick $(echo $msg | cut -d " " -f 2-)" >> $SCRIPTS/irc/afk.txt
				echo "You are now afk~" > $in
			else
				sed -i "s/$nick .*/$nick $(echo $msg | cut -d " " -f 2-)/g" $SCRIPTS/irc/afk.txt
				echo "You are now afk~" > $in
			fi

		# Get afk message
		elif [[ $msg == ".afk" ]]; then
			count=$(cat $SCRIPTS/irc/afk.txt | wc -l)

			for (( number=1; number<=$count; number++ )); do
				echo "$(cat $SCRIPTS/irc/afk.txt | head -n $number | tail -n 1 | cut -d " " -f 1) is afk because: $(cat $SCRIPTS/irc/afk.txt | head -n $number | tail -n 1 | cut -d " " -f 2-)" > $in
			done

		# Calculator
		elif [[ $msg == ".calc "* ]]; then
			echo "$(echo $msg | cut -d " " -f 2-)" | bc -l > $in

		# Calculator error
		elif [[ $msg == ".calc" ]]; then
			echo "Please enter a calculation~" > $in

		# Count words
		elif [[ $msg == ".count "* ]]; then
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

		# Grep error
		elif [[ $msg == ".count" ]]; then
			echo "Please specify at least one search term~" > $in

		# Check date
		elif [[ $msg == ".date" ]]; then
			date +"The date is %d %B~" > $in

		# Check day
		elif [[ $msg == ".day" ]]; then
			day=$(date +"%u")

			# TODO: Test this, make vista and onodera versions
			if [[ $day -le 5 ]]; then
				left=$(expr 5 - $(date +"%u"))

				if [[ $left -eq 1 ]]; then
					date +"Today is a %A, $left day left until the weekend~" > $in
				else
					date +"Today is a %A, $left days left until the weekend~" > $in
				fi
			else
				date +"Today is a %A~" > $in
			fi

		# Get a fortune
		elif [[ $msg == ".fortune"* ]]; then
			word=$(echo $msg | cut -d " " -f 2)

			if [[ $word == "tech" ]]; then
				fortune -a -s computers linux linuxcookie > $in
			elif [[ $word ==  "paradox" ]]; then
				fortune -a -s paradoxum > $in
			elif [[ $word == "science" ]]; then
				fortune -a -s science > $in
			elif [[ $word == "cookie" ]]; then
				fortune -a -s goedel > $in
			else
				echo "Please choose one of the following items: cookie paradox science tech" > $in
			fi

		# Grep through logs
		# TODO: Rice this with color.
		elif [[ $msg == ".grep "* ]]; then
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

		# Grep error
		elif [[ $msg == ".grep" ]]; then
			echo "Please specify at least one search term~" > $in

		# Set intro message
		elif [[ $msg == ".intro "* ]]; then
			if [[ -z $(cat $SCRIPTS/irc/intro.txt | grep "$nick") ]]; then
				echo "$nick $(echo $msg | cut -d " " -f 2-)" >> $SCRIPTS/irc/intro.txt
				echo "Intro set~" > $in
			else
				sed -i "s/$nick .*/$nick $(echo $msg | cut -d " " -f 2-)/g" $SCRIPTS/irc/intro.txt
				echo "Intro set~" > $in
			fi

		# Get intro message
		elif [[ $msg == ".intro" ]]; then
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

		# Leave message
		elif [[ $msg == ".msg "* ]]; then
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

		# Get message
		elif [[ $msg == ".msg" ]]; then
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

		# ping
		elif [[ $msg == ".ping" ]]; then
			echo "pong~" > $in

		# Post random quote
		# TODO: Rice this with color.
		# TODO: Ad random *.
		elif [[ $msg == ".random" ]]; then
			cat $out | grep "<$nick>" | shuf -n 1 | cut -d " " -f 3- > $in

		# Reload punyama
		elif [[ $msg == ".reload" ]]; then
			bash $SCRIPTS/irc/punyama.sh & disown
			exit

		# Download from git and reload punyama
    		elif [[ $msg == ".regit" ]]; then
			curl https://raw.githubusercontent.com/onodera-punpun/scripts/master/irc/punyama.sh > $SCRIPTS/irc/punyama.sh
			bash $SCRIPTS/irc/punyama.sh & disown
			exit

		# Check time
		# TODO: Add betime thingy
		elif [[ $msg == ".time" ]]; then
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

	fi

done > $in
