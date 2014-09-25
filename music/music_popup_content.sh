#!/bin/bash

# TODO: Fix the non-latin character bug
# TODO: Fix some latin characters getting cut off
# TODO: Fix missing bar and |

# Define colors
foreground="\e[0;39m"
black="\e[0;30m"
brown="\e[0;33m"
green="\e[1;32m"
red="\e[1;35m"
white="\e[1;37m"

# Get MPD track data
album=$(mpc -f "%album%" | head -n 1 | cut -c -22)
date=$(mpc -f "%date%" | head -n 1)
artist=$(mpc -f "%artist%" | head -n 1 | cut -c -29)
title=$(mpc -f "%title%" | head -n 1 | cut -c -29)
genre=$(mpc -f "%genre%" | head -n 1 | cut -c -29)

# Get progress % of song
percent=$(mpc | grep -o "[(0-9][0-9]%" | grep -o "[0-9]*")

# Define the lenght of the elapsed part
case $percent in
[0-2])
	bar="$black──────────────────────────────"
	;;
[3-5])
	bar="─$black─────────────────────────────"
	;;
[6-9])
	bar="──$black────────────────────────────"
	;;
1[0-2])
	bar="───$black───────────────────────────"
	;;
1[3-5])
	bar="────$black──────────────────────────"
	;;
1[6-9])
	bar="─────$black─────────────────────────"
	;;
2[0-2])
	bar="──────$black────────────────────────"
	;;
2[3-5])
	bar="───────$black───────────────────────"
	;;
2[6-9])
	bar="────────$black──────────────────────"
	;;
3[0-2])
	bar="─────────$black─────────────────────"
	;;
3[3-5])
	bar="──────────$black────────────────────"
	;;
3[6-9])
	bar="───────────$black───────────────────"
	;;
4[0-2])
	bar="────────────$black──────────────────"
	;;
4[3-5])
	bar="─────────────$black─────────────────"
	;;
4[6-9])
	bar="──────────────$black────────────────"
	;;
5[0-2])
	bar="───────────────$black───────────────"
	;;
5[3-5])
	bar="────────────────$black──────────────"
	;;
5[6-9])
	bar="─────────────────$black─────────────"
	;;
6[0-2])
	bar="──────────────────$black────────────"
	;;
6[3-5])
	bar="───────────────────$black───────────"
	;;
6[6-9])
	bar="────────────────────$black──────────"
	;;
7[0-2])
	bar="─────────────────────$black─────────"
	;;
7[3-5])
	bar="──────────────────────$black────────"
	;;
7[6-9])
	bar="───────────────────────$black───────"
	;;
8[0-2])
	bar="────────────────────────$black──────"
	;;
8[3-5])
	bar="─────────────────────────$black─────"
	;;
8[6-9])
	bar="──────────────────────────$black────"
	;;
9[0-2])
	bar="───────────────────────────$black───"
	;;
9[3-5])
	bar="────────────────────────────$black──"
	;;
9[6-9])
	bar="─────────────────────────────$black─"
	;;
100)
	bar="──────────────────────────────$black"
	;;
esac

# Send content to music_popup.sh
echo -e "$black                 |  ${foreground}Album: $brown$album"
echo -e "$black                 |  ${foreground}Date: $brown$date"
echo -e "$black                 |"
echo -e "$black                 |  ${foreground}Genre: $brown$genre"
echo -e "$black                 |"
echo -e "$black                 |  ${foreground}Artist: $green$artist"
echo -e "$black                 |  ${foreground}Track: $red$title"
echo -e "$black                 |"
echo -e "$black                 |  $white$bar"
