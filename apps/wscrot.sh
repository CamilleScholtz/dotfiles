#!/bin/bash

# Take screenshot
scrot -b -s

# Display notification
bash $SCRIPTS/notify/capture_wscrot.sh & disown
