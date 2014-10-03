#!/bin/bash

# Take screenshot
scrot -b -s

# Display notification
bash $HOME/.scripts/notify/capture_wscrot.sh & disown
sleep 0.1
