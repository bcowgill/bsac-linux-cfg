#!/bin/bash
# toggle sound by setting master level to zero after saving current level

CARD=1
LEVEL=`get-sound-level.sh`
SAVE=$HOME/.sound-toggle

if [ $LEVEL == 0% ]; then
	LEVEL=
	if [ -f $SAVE ]; then
		LEVEL=`cat $SAVE`
	fi
else
	echo $LEVEL > $SAVE
	LEVEL=0%
fi

LEVEL=${LEVEL:-70%}
sound-set.sh $LEVEL
