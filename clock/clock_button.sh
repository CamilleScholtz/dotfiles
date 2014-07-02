#!/bin/bash

# Get color from .Xresources
color=$(cat ~/.Xresources | grep background | tail -c 8)

# Kill old clocks
pkill -f "dzen2 -p -dock -title-name clock_button"*

# Determine the right width of the button
day=$(date +'%A' | wc -c)
width=$(expr $day \* 13 + 72)

# Spawn clock
sh /home/kamiru/.scripts/clock/clock_content.sh | dzen2 -p -dock -title-name clock_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w $width -h 34
