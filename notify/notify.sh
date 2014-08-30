#!/bin/bash

# Kill old notifications
pkill -f "urxvt -name notification"

# Kill old scripts
exist=$(pgrep -f "bash $HOME/.scripts/notify/notify.sh" | wc -w)
if [[ $exist -ge 3 ]]; then
	pkill -fo "bash $HOME/.scripts/notify/notify.sh"
fi

# Get the notification text
text=$(cat $HOME/.scripts/notify/text)

# Calculate the width of the spawned notification, $weeb and $gook add extra width if there are non-latin characters in the output
count=$(echo $text | wc -m)
weeb=$(echo $text | pcregrep -o "[^\x00-\x7F]" | wc -m)
gook=$(expr $weeb / 3)
width=$(expr $count - 1 + $gook)

# Get color from .Xresources
color=$(cat $HOME/.Xresources | grep background | tail -c 8)

# Spawn new notification, and kill it after 4 seconds, give it the the term-name Notification so other programs (like FVWM) can interact with it
urxvt -name notification -geometry "$width"x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e echo -n "$text" & disown
sleep 4
pkill -f "urxvt -name notification"