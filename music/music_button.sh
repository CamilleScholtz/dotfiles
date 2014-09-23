#!/bin/bash

# Define colors
red=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

# Kill old music button
pkill -f "dzen2 -p -dock -title-name music_button"*

# Sleep because otherwise mvwm will fuck up
sleep 0.1

# Send content to music_button.sh
echo "^fg($red)^i($HOME/.scripts/music/icon.xbm)" |

# Spawn music button
dzen2 -p -dock -title-name music_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 40 -h 40 -e 'button1=exec:bash $HOME/.scripts/music/music_popup.sh;' & disown
