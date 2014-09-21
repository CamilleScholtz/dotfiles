#!/bin/bash

# Combine all the variables into a single output and send this to notify.sh
echo "Torrent finished: $TR_TORRENT_NAME" > $HOME/.scripts/notify/text

# Tell notify.sh that it needs to display a notication
exec bash $HOME/.scripts/notify/notify.sh & disown