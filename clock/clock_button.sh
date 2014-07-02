#!/bin/bash

# Get color from .Xresources
color=$(cat ~/.Xresources | grep background | tail -c 8)

# Kill old clocks
pkill -f "urxvt -name clock_button"*

# Determine the right width of the button
day=$(date +'%A' | wc -c)
width=$(expr $day + 12)

# Spawn clock
exec urxvt -name clock_button -geometry ${width}x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch -c -t sh ~/.scripts/clock/clock_content.sh & disown
