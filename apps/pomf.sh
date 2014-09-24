#!/bin/bash

# Check if the user wants to take a scrot or if the user wants to upload an image/file
if [[ $# -eq 0 ]]; then
	# Take scrot
	file=$(scrot '%Y-%m-%d_scrot.png' -e 'echo -n $f')
else
	# Get file
	file="$@"
fi

# Upload it and grab the url
output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")
pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.png",' | sed 's/"url":"//;s/",//')
url=http://a.pomf.se/$pomffile

# Copy link to clipboard
echo $url | xclip -selection primary
echo $url | xclip -selection clipboard

# Print url in terminal (if used)
echo $url

if [[ $# -eq 0 ]]; then
	# Remove file
	rm -f $file
	
	# Display notification
	sleep 0.1
	bash $HOME/.scripts/notify/capture_pomf.sh $url & disown
fi
