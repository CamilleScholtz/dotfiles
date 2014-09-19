#!/bin/bash

# Take scrot
file=$(scrot '%Y-%m-%d_scrot.png' -e 'echo -n $f')

# Upload it and grab the url
output=$(curl --silent -sf -F files[]="@$file" "http://pomf.se/upload.php")
pomffile=$(echo "$output" | grep -Eo '"url":"[A-Za-z0-9]+.png",' | sed 's/"url":"//;s/",//')
url=http://a.pomf.se/$pomffile

# Copy link to clipboard
echo $url | xclip -selection primary
echo $url | xclip -selection clipboard

# Print url in terminal (if used)
echo $url

# Remove file
rm -f $file

# Display notification
sleep 0.1
bash $HOME/.scripts/notify/capture_pomf.sh $url & disown
