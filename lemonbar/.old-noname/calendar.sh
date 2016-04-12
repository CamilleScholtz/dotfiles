#!/bin/bash

exist="$(pgrep -f "urxvt -g 21x8")"
if [[ -n "$exist" ]]; then
	pkill -f "feh --title calendar_arrow"
	pkill -f "urxvt -g 21x8"
	pkill -f "bash $HOME/etc/lemoetc/lemonbar/calendar.sh"
	exit
fi

urxvt -g 21x8 -e watch -t -n 32 -c cal -m & disown

# TODO: Optimize this, lol
feh --title calendar_arrow -N -q --zoom fill -g 18x1+1472+1094 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 16x1+1473+1095 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 14x1+1474+1096 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 12x1+1475+1097 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 10x1+1476+1098 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 8x1+1477+1099 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 6x1+1478+1100 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 4x1+1479+1101 "$HOME/etc/lemonbar/assets/arrow.png" & disown
feh --title calendar_arrow -N -q --zoom fill -g 2x1+1480+1102 "$HOME/etc/lemonbar/assets/arrow.png" & disown

