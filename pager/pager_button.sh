#!/bin/bash

# Kill old buttons
pkill -f "dzen2 -p -dock -title-name pager_button"*

# Spawn music button
bash /home/onodera/.scripts/pager/pager_content.sh | dzen2 -p -dock -title-name pager_button -fn -gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1 -ta c -w 34 -h 34
