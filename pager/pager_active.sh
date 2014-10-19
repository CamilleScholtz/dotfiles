#!/bin/bash

# Kill old active icon
if [[ -n $(pgrep -f "feh --title pager_active") ]]; then
	pkill -f "feh --title pager_active"
	pkill -f -o "bash $SCRIPTS/pager/pager_active.sh"
fi

# Get active workspace
active=$(wmctrl -d | grep "*" | cut -c 1)

# Spawn active icon
if [[ $active -eq 0 ]]; then
	feh --title pager_active -N --zoom fill -g 55x40+1617++1120 "$SCRIPTS/pager/pager_active.png" & disown
	sleep 0.33
	pkill -f "feh --title pager_active"
	exit
elif [[ $active -eq 1 ]]; then
	feh --title pager_active -N --zoom fill -g 55x40+1673++1120 "$SCRIPTS/pager/pager_active.png" & disown
	sleep 0.33
	pkill -f "feh --title pager_active"
	exit
elif [[ $active -eq 2 ]]; then
	feh --title pager_active -N --zoom fill -g 55x40+1729+1120  "$SCRIPTS/pager/pager_active.png" & disown
	sleep 0.33
	pkill -f "feh --title pager_active"
	exit
elif [[ $active -eq 3 ]]; then
	feh --title pager_active -N --zoom fill -g 55x40+1785+1120 "$SCRIPTS/pager/pager_active.png" & disown
	sleep 0.33
	pkill -f "feh --title pager_active"
	exit
fi
