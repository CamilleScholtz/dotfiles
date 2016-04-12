#!/bin/bash

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
foreground="$(grep "^*foreground" "$HOME/.Xresources" | tail -c 7)"
magenta="$(grep "^*color13:" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1,-misc-fixed-medium-r-normal-ja-13-120-75-75-c-120-iso10646-1

while true; do
	artist="$(mpc -f "%artist%" | head -n 1)"
	artistfm="$(echo "$artist" | sed "s/ /+/g")"

	echo "%{A:firefox "www.last.fm/music/$artistfm" & disown:}%{F#FF$foreground}Artist: %{F#FF$magenta}$artist%{A}"

	sleep 0.2
done |
bar -g 263x14+215+933 -d -f $font -p -B \#FF$background | bash
