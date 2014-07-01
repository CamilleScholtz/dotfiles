#!/bin/bash

# Get color from .Xresources
color=$(cat /home/kamiru/.Xresources | grep background | tail -c 8)

# Kill old buttons
pkill -f "urxvt -name todo_button"*

# Spawn todo button
exec urxvt -name todo_button -geometry 20x1 -internalBorder 10 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch -t -c sh /home/kamiru/.scripts/todo/todo_content.sh & disown
