#!/bin/bash

red=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

# Send content to music_button.sh
echo "^fg($red)^i($HOME/.scripts/music/icon.xbm)"
