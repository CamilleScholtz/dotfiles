#!/bin/bash

# Kill old buttons
pkill -f "dzen2 -p -dock -title-name todo_button"*

# Spawn music button
bash /home/onodera/.scripts/todo/todo_content.sh | dzen2 -p -dock -title-name todo_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 162 -h 34 -e 'button1=exec:urxvt -e ne /home/onodera/.scripts/todo/text;'