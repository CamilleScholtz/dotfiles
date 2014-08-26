#!/bin/bash

# Kill old buttons
pkill -f "dzen2 -p -dock -title-name reminder_button"*

# Spawn music button
sleep 0.2
bash /home/onodera/.scripts/reminder/reminder_content.sh | exec dzen2 -p -dock -title-name reminder_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 146 -h 34 -e 'button1=exec:urxvt -e ne /home/onodera/.scripts/reminder/text;' & disown