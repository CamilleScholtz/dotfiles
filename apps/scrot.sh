#!/bin/bash

# Display notification
bash $SCRIPTS/notify/capture_scrot.sh & disown
sleep 0.2

# Take screenshot
scrot
