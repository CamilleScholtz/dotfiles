#!/bin/bash

# Combine all the variables into a single output and send this to notify.sh
echo "Torrent finished: $@" > $HOME/.scripts/notify/text

# Tell notify.sh that it needs to display a notication
exec bash $HOME/.scripts/notify/notify.sh & disown