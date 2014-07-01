#!/bin/bash

# Define colors
white='\e[0;39m'
pink='\e[1;35m'

# Get the time
time=$(date +'%A, %I:%M %p')

# Send content to clock_button.sh
echo -e -n "$pink¼$white  $time"
