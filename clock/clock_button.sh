#!/bin/bash

# Define colors
foreground=$(cat $HOME/.Xresources | grep foreground | tail -c 8)
magenta=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

# Kill old clocks
pkill -f "dzen2 -title-name clock_button"*

# Sleep because otherwise mvwm will fuck up
sleep 0.1

# Calculate the width of the spawned clock
# TODO: Fix $width when day is changed
count=$(date +"%A" | wc -c)
width=$(expr $count \* 8 + 127)

# Clock content
while true; do
	# Get the time
	time=$(date +"%A, %I:%M %p")

	# Send content to clock_button.sh
	echo "^fg($magenta)^i($SCRIPTS/clock/clock_icon.xbm)^fg($foreground)  $time"

	sleep 30
done |

# Spawn clock (dzen/bar)
dzen2 -title-name clock_button -p -geometry +40-80 -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w $width -h 40 -e 'onstart=lower' & disown
