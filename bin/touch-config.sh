#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

#xinput --list
#xinput --list --long 15
#xinput --test   # show events for device as they happen

function get_usb_id
{
	local type text
	type="$1"
	text="$2"
	echo $type:
	RET=`xinput --list | grep "$text" | perl -pne 's{\A .+ id=(\d+) .+ \z}{$1}xms;'`
	xinput --list | grep "$text"
}

# Mouse/touch configuration default
get_usb_id mouse "USB Optical Mouse"
export MOUSE="$RET"
get_usb_id mouse "Logitech MX Anywhere"
export MOUSE="$MOUSE $RET"
get_usb_id mouse "Logitech USB Receiver"
export MOUSE="$MOUSE $RET"
get_usb_id mouse "Mitsumi Electric Apple Optical USB Mouse"
export MOUSE="$MOUSE $RET"

get_usb_id touch Touchpad
export TOUCH_PAD=$RET
export TOUCH_NIPPLE=
export TOUCH_SCREEN=

if [ $HOSTNAME == "akston" ]; then
	# Mouse/touch configuration for my dell laptop
	get_usb_id touch/nipple "ImPS/2 Generic Wheel Mouse"
	export TOUCH_PAD=$RET
	export TOUCH_NIPPLE=$RET
fi

if [ "$HOSTNAME" == "brent-Aspire-VN7-591G" ]; then
	# Mouse/touch configuration for clearbooks laptop
	export TOUCH_NIPPLE=
	export TOUCH_SCREEN=
fi

export TOUCH="$TOUCH_PAD $TOUCH_NIPPLE $TOUCH_SCREEN"
echo "xinput mouse device ids: $MOUSE"
echo "xinput touch device ids: $TOUCH"

