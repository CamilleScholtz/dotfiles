#!/bin/bash

# Display notification
bash $HOME/.scripts/notify/capture_wscrot.sh & disown
sleep 0.1

# Take screenshot
scrot -b -u
