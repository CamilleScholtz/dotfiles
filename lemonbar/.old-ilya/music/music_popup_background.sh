#!/bin/bash

background="$(grep "^*background:" "$HOME/.Xresources" | tail -c 7)"

echo "" |
bar -g 286x152+192+868 -d -p -B \#FF$background
