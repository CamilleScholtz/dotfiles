#!/bin/bash

# TODO: 100% CPU!?

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
magenta="$(grep "^*color13" "$HOME/.Xresources" | tail -c 7)"

pkill -f "bar -g 40x40\+1840\+1120"

echo "%{c}%{F#FF$magenta}%{I$HOME/.bar/pager/pager_icon.xbm}" |
bar -g 40x40+1840+1120 -d -p -B \#FF$background
