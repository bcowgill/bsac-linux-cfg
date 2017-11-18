#!/bin/bash
# save a png of what the moon currently looks like.
OUTPUT=$HOME/d/Dropbox/Photos/Wallpaper/WorkSafe/astronomy-photos/earth-moon
URL=http://aa.usno.navy.mil/imagery/moon
URL="http://api.usno.navy.mil/imagery/moon.png?&ID=AA-URL"
FILE=$OUTPUT/moon-phase-`datestampfn.sh`.png

echo $FILE
wget --output-document $FILE "$URL"
