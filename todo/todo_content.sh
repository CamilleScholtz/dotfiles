#!/bin/bash

# Define colors
pink='\e[1;35m'
white='\e[1;38m'

# Get number of todo's
count=&(cat /home/kamiru/Dropbox/todo/todo.txt | sed '/^\s*$/d' | wc -l)

# Send content to clock_button.sh
echo -e  "$count things in todo list  $pink¾"
