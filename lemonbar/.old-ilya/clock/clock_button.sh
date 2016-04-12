#!/bin/bash

# TODO: Fix bar being always on top

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
foreground="$(grep "^*foreground" "$HOME/.Xresources" | tail -c 7)"
magenta="$(grep "^*color13" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1

count="$(date +"%A" | wc -c)"
width="$(expr $count \* 8 + 127)"

# TODO: Kill script too
pkill -f "bar -g ${width}x40\+40\+1120"

while true; do
	time="$(date +"%A, %I:%M %p")"

	countnew="$(date +"%A" | wc -c)"
	if [[ "$count" -ne "$countnew" ]]; then
		bash "$HOME/.bar/clock/clock_button.sh" &
		exit
	fi

	echo "%{c}%{F#FF$magenta}%{I$HOME/.bar/clock/clock_icon.xbm}%{F#FF$foreground}  $time"

	sleep 30
done |
bar -g ${width}x40+40+1120 -d -f $font -p -B \#FF$background
