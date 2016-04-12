#!/bin/bash

# TODO: Fix bar being always on top

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
magenta="$(grep "^*color13" "$HOME/.Xresources" | tail -c 7)"

pkill -f "bar -g 40x40\+40\+1040"

echo "%{c}%{A:bash $HOME/.bar/music/music_popup.sh & disown:}%{F#FF$magenta}%{I$HOME/.bar/music/music_icon.xbm}%{A}" |
bar -g 40x40+40+1040 -d -p -B \#FF$background | bash
