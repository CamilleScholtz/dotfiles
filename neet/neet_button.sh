#!/bin/bash

# Define colors
foreground=$(cat $HOME/.Xresources | grep foreground | tail -c 8)
magenta=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

# Kill old neet buttons
pkill -f "dzen2 -title-name neet_button"*

# Sleep because otherwise mvwm will fuck up
sleep 0.1

# Calculate the withd of the spawned neet button
# TODO: Fix $width when escapism name is changed
current=$(cat $SCRIPTS/neet/text.patch | grep "*" | cut -c 3-)
count=$(echo $current | wc -c)
width=$(expr $count \* 8 + 40)
right=$(expr $width + 40)

while true; do
	# Get current escapism
	current=$(cat $SCRIPTS/neet/text.patch | grep "*" | cut -c 3-)

	# Send content to neet_button.sh
	echo "^fg($foreground)$current ^fg($magenta)^i($SCRIPTS/neet/neet_icon.xbm)"

	sleep 30
done |

# Spawn escapism button
dzen2 -title-name neet_button -p -geometry -$right-160 -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w $width -h 40 -e 'onstart=lower;button1=exec:bash $SCRIPTS/apps/neet.sh;' & disown
