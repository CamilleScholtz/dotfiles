#!/bin/bash

# TODO: Fix cursor glitch thingy

# Get color from .Xresources
color=$(cat /home/kamiru/.Xresources | grep background | tail -c 8)

# Kill old buttons
pkill -f "urxvt -name todo_button"*

# Spawn button
exec urxvt -name todo_button -geometry 2x1 -internalBorder 0 -hold -cursorUnderline -cursorColor $color -cursorColor2 $color -e watch  -t "cat /home/kamiru/Dropbox/todo/todo.txt | sed '/^\s*$/d' | wc -l"
