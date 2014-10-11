#!/bin/bash

# TODO: Fix $track sometimes diplaying XX/XX ans sometimes only XX
# TODO: Use skroll

# Define colors
foreground="\e[0;39m"
black="\e[0;30m"
brown="\e[0;33m"
green="\e[1;32m"
magenta="\e[1;35m"
white="\e[1;37m"

while true; do
	# Get MPD track data
	albumcount=$(expr $(mpc -f "%album%" | head -n 1 | cut -c -23 | pcregrep -o "[^\x00-\x7F]" | wc -m) / 2 - 2)
	album=$(mpc -f "%album%" | head -n 1 | cut -c -$(expr 23  + $albumcount))

	date=$(mpc -f "%date%" | head -n 1)

	artistcount=$(expr $(mpc -f "%artist%" | head -n 1 | cut -c -22 | pcregrep -o "[^\x00-\x7F]" | wc -m) / 2)
	artist=$(mpc -f "%artist%" | head -n 1 | cut -c -$(expr 22 + $artistcount))

	titlecount=$(expr $(mpc -f "%title%" | head -n 1 | cut -c -23 | pcregrep -o "[^\x00-\x7F]" | wc -m) / 2)
	title=$(mpc -f "%title%" | head -n 1 | cut -c -$(expr 23 + $titlecount))

	track=$(mpc -f "%track%" | head -n 1)

	# Get progress % of song
	elapsed=$(bc <<< "sclae=2; $(mpc | grep -o '[(0-9][0-9]%' | grep -o '[0-9]*')/3.571")
	togo=$(expr 28 - $elapsed)

	# Create bar
	bar1=$(eval "printf '─%.0s' {0..$elapsed}")
	bar2=$(eval "printf '─%.0s' {0..$togo}")

	# Echo stuff
	echo -e    "$black                 │  ${foreground}Album: $brown$album"
	echo -e    "$black                 │  ${foreground}Date: $brown$date"
	echo -e    "$black                 │"
	echo -e    "$black                 │  ${foreground}Track: $brown$track"
	echo -e    "$black                 │"
	echo -e    "$black                 │  ${foreground}Artist: $green$artist"
	echo -e    "$black                 │  ${foreground}Title: $magenta$title"
	echo -e    "$black                 │"
	echo -e -n "$black                 │  $white$bar1$black$bar2"

	sleep 0.5
done
