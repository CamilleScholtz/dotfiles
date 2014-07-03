#!/bin/bash

SCROTARGS=()
 
# take the shot
file="`scrot ${SCROTARGS[@]} -e 'echo -n $f'`"
 
# upload it and grab the url
base=""; try=0
while [[ "x$base" == "x" ]] && [[ $try -lt 3 ]]; do
try=$[$try + 1]
echo "Uploading~ (try $try)"
json="`curl -sf -F "files[]=@$file" http://pomf.se/upload.php`"
base="`echo "$json" | python -c "from __future__ import print_function;print(__import__('json').loads(__import__('sys').stdin.read())['files'][0]['url'])" 2>/dev/null`"
done
 
if [[ $try -eq 3 ]]; then
echo "Giving up ;_;"
exit 1
fi
 
url="http://a.pomf.se/$base"

# copy the url to the clipboard
echo -n "$url" | xclip -selection clipboard
echo "$url (has been copied to clipboard)"
notify-send -t 5 "pomf~" "$url"
 
rm -f "${file}"
