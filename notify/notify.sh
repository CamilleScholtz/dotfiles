#!/bin/bash

# Get the notification text
text=$(cat /home/kamiru/.scripts/notify/text)

# Calculate the width of the spawned notification, $weeb and $gook add extra width if there are non-latin characters in the output
count=$(echo $text | wc -m)
weeb=$(echo $text | pcregrep -o "[^\x00-\x7F]" | wc -m)
gook=$(expr $weeb / 3)
width=$(expr $count - 1 + $gook)

# Kill old notifications and scripts, if we don't do this the notifications will glitch through each other
pkill -f "urxvt -name notification"
exist=$(pgrep -f "sh /home/kamiru/.scripts/notify/notify.sh" | wc -w)
if [[ $exist -ge 3 ]]; then
	pkill -fo "sh /home/kamiru/.scripts/notify/notify.sh"
fi

# Get color from .Xresources       
color=$(cat /home/kamiru/.Xresources | grep background | tail -c 8)

# Spawn new notification, and kill it after 4 seconds, give it the the term-name Notification so other programs (like FVWM) can interact with it
urxvt -name notification -geometry "$width"x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n $text & disown
sleep 4
pkill -f "urxvt -name notification"
