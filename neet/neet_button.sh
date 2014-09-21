#!/bin/bash

# Kill old neet buttons
pkill -f "dzen2 -p -dock -title-name neet_button"*

# Calculate the withd of the spawned neet button
# TODO: Fix $width when escapism name is changed
current=$(cat $HOME/.scripts/neet/text.patch | grep "*" | cut -c 3-)
count=$(echo $current | wc -c)
width=$(expr $count \* 8 + 40)

# Spawn escapism button
sleep 0.2
bash $HOME/.scripts/neet/neet_content.sh | exec dzen2 -p -dock -title-name neet_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w $width -h 40 -e 'button1=exec:urxvt -e $EDITOR $HOME/.scripts/neet/text.patch;' & disown
