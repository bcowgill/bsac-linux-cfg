#!/bin/bash
# set Master sound level to 50% for all sound cards

level=${1:-100%}

for card in `sound-cards.sh`
do
	echo card: $card
	for mixer in Master IEC958
	do
		amixer -c $card -- sset $mixer playback $level 2> /dev/null
	done
done

