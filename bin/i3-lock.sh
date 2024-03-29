#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# lock the screen with xscreensaver or i3-lock

lemonchiffon=FFFACD
brick=683232
mygray=4c4444
darkblue=000033
lockcolor=$lemonchiffon
lockcolor=$brick
lockcolor=$mygray
lockcolor=$darkblue

#i3lock -c $lockcolor -d
#xscreensaver-command -lock

if [ ! -z "$1" ]; then
	i3lock -c $lockcolor -d
	exit 0
fi

if which xscreensaver-command ; then
	if xscreensaver-command -lock ; then
		exit 0
	else
		xscreensaver &
		sleep 1
		if xscreensaver-command -lock ; then
			exit 0
		else
			i3lock -c $lockcolor -d
		fi
	fi
else
	i3lock -c $lockcolor -d
fi
