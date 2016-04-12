#!/bin/bash

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
foreground="$(grep "^*foreground" "$HOME/.Xresources" | tail -c 7)"
brown="$(grep "^*color11:" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1,-misc-fixed-medium-r-normal-ja-13-120-75-75-c-120-iso10646-1

while true; do
	album="$(mpc -f "%album%" | head -n 1)"
	albumfm="$(echo "$album" | sed "s/ /+/g")"
	artistfm="$(mpc -f "%artist%" | head -n 1 | sed "s/ /+/g")"

	echo "%{A:firefox "www.last.fm/music/$artistfm/$albumfm" & disown:}%{F#FF$foreground}Album: %{F#FF$brown}$album%{A}"

	sleep 0.2
done |
bar -g 263x14+215+891 -d -f $font -p -B \#FF$background | bash
