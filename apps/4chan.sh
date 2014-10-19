#!/bin/bash

# Check if the user entered a board and search term
if [[ -z "$@" ]]; then
	echo "You must supply a board and search term."
	exit
elif [[ -n $1 && -z $2 ]]; then
	echo "You must supply a search term."
	exit
elif [[ -n $1 && -z $2 ]]; then
	echo "You must supply a search term."
	exit
fi

url="https://boards.4chan.org/$1/$2"
data=$(curl "$url")
echo $data
