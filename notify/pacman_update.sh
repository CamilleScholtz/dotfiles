#!/bin/bash

# TODO: Make this

# Combine all the variables into a single output and send this to notify.sh
echo "Installation finished: $@" > $SCRIPTS/notify/text

# Tell notify.sh that it needs to display a notication
exec bash $SCRIPTS/notify/notify.sh & disown
