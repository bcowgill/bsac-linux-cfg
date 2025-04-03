#!/bin/bash
# set keyboard backlight brightness
# You can also do it with Fn-F10 on Dell Precision 7510 check your keyboard keys

DEV=dell::kbd_backlight

LEVEL=2  # 0..2 for brightness allowed
if [ ! -z "$1" ]; then
	LEVEL=$1
fi

if brightnessctl -l | grep $DEV > /dev/null; then
	brightnessctl --device $DEV set $LEVEL
else
	if brightnessctl -l | grep -A 2 kbd_backlight ; then
		>&2 echo $DEV is not the correct device for keyboard brightness, change the setting in this script and try again.
	fi
fi
