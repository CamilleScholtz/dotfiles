#!/bin/bash

# Get all info from transmission-remote
info=$(transmission-remote 192.168.178.57 -l)

# Get number of lines
lines=$(echo "$info" | wc -l)
# Get acual number of torrents by removing the two information lines
count=$(expr $lines - 2)

# Get the individual torrent lines (this is some 1337 bash stuff right here)
mapfile -t -s 1 -n $count torrent < <(echo "$info")

# Get the torrent names, status, etc.
for (( number=0; number<=$count; number++ )); do
	# Get the percentage completed
	percent[$number]=$(echo ${torrent[$number]} | grep -o '[ 0-9][0-9]%')
	
	# Fix 100% showing up as 00%
	if [[ ${percent[$number]} == '00%' ]]; then
	
		percent[$number]='100%'
	fi

	# Get the torrent name
	name[$number]=$(echo ${torrent[$number]} | sed -n -e 's/^.*Idle \|^.*Seeding \|^.*Stopped //p')
	
	# Get the torrent status
	status[$number]=$(echo ${torrent[$number]} | grep -o 'Idle\|Seeding\|Stopped')
done

# Draw shit
echo "${status[0]} - ${name[0]}"
echo "   ${percent[0]}"
echo ""

echo "${status[1]} - ${name[1]}"
echo "   ${percent[1]}"
echo ""

echo "${status[2]} - ${name[2]}"
echo "   ${percent[2]}"
echo ""
