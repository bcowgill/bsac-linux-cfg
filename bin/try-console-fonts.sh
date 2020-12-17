#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# cycle through all console fonts of a certain size
# asking Y or N for a font you like
SETFONT=/bin/setfont
DIR='/usr/share/consolefonts/Uni*32*'
#DIR='/usr/share/consolefonts/Uni*28*'
#DIR='/usr/share/consolefonts/Uni*24*'

for font in $DIR
do
	echo $font
	$SETFONT $font
	echo "Do you like this font [y/N] ? "
	read OK
	if [ "$OK" == "y" ]; then
		echo adding to set-console-font.sh
		echo $SETFONT $font >> set-console-font.sh
	fi
done

