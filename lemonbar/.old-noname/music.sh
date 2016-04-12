#!/bin/bash

exist="$(pgrep -f "music_bg")"
if [[ -n "$exist" ]]; then
	pkill -f "feh --title music_arrow"
	pkill -f "feh --title music_art"
	pkill -f "feh --title music_bg"
	pkill -f "bash $HOME/etc/lemonbar/music.sh"
	exit
fi

feh --title music_bg -q -N -g 300x300+800+778 "$HOME/etc/lemonbar/assets/music_bg.png" & disown

cover() {
	if [[ -f "$HOME/usr/music/$path/cover_popup.png" ]]; then
		feh --title music_art -q -N -g 300x300+800+778 "$HOME/usr/music/$path/cover_popup.png" & disown
	else
		feh --title music_art -q -N -g 300x300+800+778 "$HOME/etc/lemonbar/assets/music_nocover.png" & disown
	fi
}

# TODO: Optimize this, lol
feh --title music_arrow -N -q --zoom fill -g 18x1+952+1098 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 16x1+953+1099 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 14x1+954+1100 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 12x1+955+1101 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 10x1+956+1102 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 8x1+957+1103 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 6x1+958+1104 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 4x1+959+1105 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title music_arrow -N -q --zoom fill -g 2x1+960+1106 "$HOME/etc/lemonbar/assets/arrow.png" & disown

path="$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")"
cover

while true; do
	pathnew="$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")"

	if [[ "$path" != "$pathnew" ]]; then
		path="$(mpc -f "%file%" | head -n 1 | cut -f 1-2 -d "/")"
		pathnew="$path"

		pkill -f "feh --title music_art"

		cover
	fi

	sleep 0.25
done
