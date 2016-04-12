#!/bin/bash

background="$(grep "^*background:" "$HOME/.Xresources" | tail -c 7)"
black="$(grep "^*color0:" "$HOME/.Xresources" | tail -c 7)"
white="$(grep "^*color15:" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1

while true; do
	elapsed="$(bc <<< "$(mpc | grep -o '[(0-9][0-9]%' | grep -o "[0-9]*")/3.571")"
	togo="$(expr 28 - $elapsed)"

	progress1="$(eval "printf "_%.0s" {0..$elapsed}")"
	progress2="$(eval "printf "_%.0s" {0..$togo}")"

	echo "%{F#FF$white}$progress1%{F#FF$black}$progress2"

	sleep 0.2
done |
bar -g 263x14+215+983 -d -f $font -p -B \#FF$background
