#!/bin/bash

# Kill old clocks
pkill -f "dzen2 -p -dock -title-name clock_button"*

# Calculate the width of the spawned clock
count=$(date +'%A' | wc -c)
width=$(expr $count \* 8 + 121)

# Spawn clock
bash /home/onodera/.scripts/clock/clock_content.sh | dzen2 -p -dock -title-name clock_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w $width -h 34 & disown
