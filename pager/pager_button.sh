#!/bin/bash

# Define colors
magenta=$(cat $DOTFILES/Xresources | grep color13 | tail -c 8)

# Kill old pager button
pkill -f "dzen2 -title-name pager_button"*

# Sleep because otherwise mvwm will fuck up
sleep 0.1

# Send content to pager_button.sh
echo "^fg($magenta)^i($SCRIPTS/pager/pager_icon.xbm)" |

# Spawn pager button
dzen2 -title-name pager_button -p -geometry -80-80 -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 40 -h 40 & disown
