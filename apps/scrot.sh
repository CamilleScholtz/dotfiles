#!/bin/bash

# Display notification
bash $HOME/.scripts/notify/capture_scrot.sh & disown
sleep 0.1

# Take screenshot
scrot
