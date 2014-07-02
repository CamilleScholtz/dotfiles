#!/bin/bash

# Get color from .Xresources
color=$(cat ~/.Xresources | grep background | tail -c 8)

# Kill old buttons
pkill -f "urxvt -name pager_button"*

exec urxvt -name pager_button -geometry 1x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e sh ~/.scripts/pager/pager_content.sh & disown
