#!/bin/bash

# Kill old music button
pkill -f "dzen2 -p -dock -title-name music_button"*

# Spawn music button
sleep 0.2
bash $HOME/.scripts/music/music_content.sh | exec dzen2 -p -dock -title-name music_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 40 -h 40 -e 'button1=exec:bash $HOME/.scripts/music/music_popup.sh;' & disown
