#!/bin/bash

# TODO: fix the non-latin character bug
# TODO: fix some latin characters getting cut off

# Get MPD track data
drama=$(cat /home/onodera/.scripts/todo/text | grep +Drama)
fashion=$(cat /home/onodera/.scripts/todo/text | grep +Fashion)
life=$(cat /home/onodera/.scripts/todo/text | grep +Life)
movie=$(cat /home/onodera/.scripts/todo/text | grep +Movie)
music=$(cat /home/onodera/.scripts/todo/text | grep +Music)
rice=$(cat /home/onodera/.scripts/todo/text | grep +Rice)

# Define colors
white='\e[1;38m'
white2='\e[1;37m'
black='\e[0;30m'

# Send content to music_popup.sh
echo -e "		    $white$date - $album"
echo -e ""
echo -e "		    $white$artist"
echo -e ""
echo -e "		    $white$title"
echo -e ""
echo -e ""
echo -e ""
echo -e "		    $white2$bar"
