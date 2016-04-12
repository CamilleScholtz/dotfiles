#!/bin/bash

# TODO: Fix bar being always on top

background="$(grep "^*background" "$HOME/.Xresources" | tail -c 7)"
foreground="$(grep "^*foreground" "$HOME/.Xresources" | tail -c 7)"
magenta="$(grep "^*color13" "$HOME/.Xresources" | tail -c 7)"

font=-gohu-gohufont-medium-r-normal--14-100-100-100-c-80-iso10646-1

escapism="$(grep "+" "$HOME/.bin/config/neet" | cut -c 3-)"
count="$(echo "$escapism" | wc -c)"
width="$(expr $count \* 8 + 40)"
right="$(expr 1920 - 40 - $width)"

pkill -f "bar -g ${width}x40\+$right\+1040"

echo "%{c}%{A:neet:}%{F#FF$foreground}$escapism  %{F#FF$magenta}%{I$HOME/.bar/neet/neet_icon.xbm}%{A}" |
bar -g ${width}x40+$right+1040 -d -f $font -p -B \#FF$background | bash
