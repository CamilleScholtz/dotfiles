#!/bin/bash

red=$(cat $HOME/.Xresources | grep color13 | tail -c 8)

# Send content to pager_button.sh
echo "^fg($red)^i($HOME/.scripts/pager/icon.xbm)"
