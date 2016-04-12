#!/bin/bash

background="$(grep "^Colorset 1" "$HOME/etc/fvwm/config" | tail -c 9 | head -c 6)"
foreground="$(grep "^*foreground" "$HOME/etc/Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1,-misc-fixed-medium-r-normal-ja-13-120-75-75-c-120-iso10646-1

desktop() {
	current="$(wmctrl -d | grep -n -o "*" | cut -c 1)"

	echo "- - - -" | sed s/-/*/$current
}

music() {
	mpc="$(mpc)"
	current="$(echo "$mpc" | head -n 1)"
	status="$(echo "$mpc" | grep -o "\[[a-z]*\]")"
	
	echo "$current $status"
}

#escampism() {
#	grep "+" "$HOME/bin/config/neet" | cut -c 3-
#}

clock() {
	date +"%a, %I:%M %p"
}

while true; do
	desktop="$(desktop)"
	music="$(music)"
	clock="$(clock)"

	echo "%{l}   $desktop   %{c}%{A:bash "$HOME/etc/lemonbar/music.sh" & disown:}   $music   %{A}%{r}%{A:bash "$HOME/etc/lemonbar/calendar.sh" & disown:}   $clock   %{A}"

	sleep 0.25
done |

lemonbar -g 1200x40+360+1120 -d -f $font -B \#FF$background -F \#FF$foreground | bash
