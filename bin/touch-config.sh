#!/bin/bash

#xinput --list
#xinput --list --long 15

function get_usb_id
{
	local text
	text="$1"
	RET=`xinput --list | grep "$text" | perl -pne 's{\A .+ id=(\d+) .+ \z}{$1}xms;'`
	xinput --list | grep "$text"
}

# Mouse/touch configuration for workshare laptop
export MOUSE=
export TOUCH_PAD=15
export TOUCH_NIPPLE=
export TOUCH_SCREEN=13

if [ $HOSTNAME == "akston" ]; then
	# Mouse/touch configuration for my dell laptop
	export MOUSE=11
	export TOUCH_PAD=12
	export TOUCH_NIPPLE=14
	export TOUCH_SCREEN=
fi

if [ "$HOSTNAME" == "brent-Aspire-VN7-591G" ]; then
	# Mouse/touch configuration for clearbooks laptop
	get_usb_id "Logitech MX Anywhere"
	export MOUSE=$RET
	get_usb_id Touchpad
	export TOUCH_PAD=$RET
	export TOUCH_NIPPLE=
	export TOUCH_SCREEN=
fi

export TOUCH="$TOUCH_PAD $TOUCH_NIPPLE $TOUCH_SCREEN"

