#!/bin/bash

# Kill old buttons
pkill -f "dzen2 -p -dock -title-name music_button"*

# Spawn music button
bash /home/onodera/.scripts/music/music_content.sh | dzen2 -p -dock -title-name music_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 34 -h 34 -e 'entertitle=exec:bash /home/onodera/.scripts/music/music_popup.sh;leavetitle=exec:sleep 1 && pkill -n feh && pkill -n urxvt;'