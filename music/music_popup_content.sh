#!/bin/bash

# TODO: fix the non-latin character bug
# TODO: fix some latin characters getting cut off

# Get MPD track data
album=$(mpc -f "%album%" | head -n 1 | head -c 22)
artist=$(mpc -f "%artist%" | head -n 1 | head -c 29)
date=$(mpc -f "%date%" | head -n 1)
title=$(mpc -f "%title%" | head -n 1 | head -c 29)

# Get progress % of song
percent=$(mpc | grep -o "[(0-9][0-9]%" | grep -o "[0-9]*")

# Define colors
# TODO: Make color same as ncmpcpp
# TODO: Make color codes same as neet.sh
white="\e[1;38m"
white2="\e[1;37m"
black="\e[0;30m"

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
echo -e "		    $white$date - $album"
echo -e ""
echo -e "		    $white$artist"
echo -e ""
echo -e "		    $white$title"
echo -e ""
echo -e ""
echo -e ""
echo -e "		    $white2$bar"
