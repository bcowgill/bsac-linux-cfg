#!/bin/bash
# darken the backlight enforcing a minimum of 1
DEC=10
if perl -e 'exit ($ARGV[0] <= $ARGV[1] ? 0 : 1)' `xbacklight -get` $DEC ; then
	xbacklight -set 1
else
	xbacklight -dec $DEC -time 500 -steps 100
fi
xbacklight -get
