#!/bin/bash

# Get amount of scrots
count=$(find $HOME/*.png 2>/dev/null | wc -w)

if [[ $count -eq 1 ]]; then
	# Remove scrots
	rm $HOME/*.png

	echo Removed $count scrot
elif [[ $count -ge 2 ]]; then
	# Remove scrots
	rm $HOME/*.png

	echo Removed $count scrots
else	
	echo No scrots to remove
fi
