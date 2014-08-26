#!/bin/bash

# Choose the direcotry where the torrent will be saved
cd /home/onodera/Downloads || exit

[[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit

hashh=${BASH_REMATCH[1]}

if [[ "$1" =~ dn=([^&/]+) ]];then
	filename=${BASH_REMATCH[1]}
else
	filename=$hashh
fi

echo "d10:magnet-uri${#1}:${1}e" > "magnet-$filename.torrent"