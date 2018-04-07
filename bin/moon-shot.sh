#!/bin/bash
# save a png of what the moon currently looks like.
OUTPUT=$HOME/d/Dropbox/Photos/Wallpaper/WorkSafe/astronomy-photos/earth-moon/moon-phases
if [ raspberrypi == $HOSTNAME ]; then
	OUTPUT=$HOME/moon-phases
fi
URL=http://aa.usno.navy.mil/imagery/moon
#URL="http://api.usno.navy.mil/imagery/moon.png?sequence=15&ID=AA-URL"
FILE=$OUTPUT/moon-phase-`datestampfn.sh`.png
TMP=`mktemp`

[ -d $OUTPUT ] || mkdir -p $OUTPUT

function get_moon
{
	wget --output-document $TMP "$URL"
	URL=`perl -ne 'if (m{"preload" [^>]+ src="([^"]+)"}xms) { print $1; exit 0; } END { exit 1; }' $TMP`
	rm $TMP
	echo image url: $URL
	wget --output-document $FILE "$URL"
}

touch $FILE
while file $FILE | grep empty;
	do get_moon;
	sleep 10
done

echo $FILE

exit 0

<img id="preload" class="alt" src="http://api.usno.navy.mil/imagery/moon.png?sequence=18&amp;ID=AA-URL" alt="What the Moon looks like now">
