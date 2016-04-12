#!/bin/bash

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
foreground="$(grep "^*foreground" "$HOME/.Xresources" | tail -c 7)"
green="$(grep "^*color10:" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1,-misc-fixed-medium-r-normal-ja-13-120-75-75-c-120-iso10646-1

while true; do
	title="$(mpc -f "%title%" | head -n 1)"

	echo "%{F#FF$foreground}Title: %{F#FF$green}$title"

	sleep 0.2
done |
bar -g 263x14+215+947 -d -f $font -p -B \#FF$background
