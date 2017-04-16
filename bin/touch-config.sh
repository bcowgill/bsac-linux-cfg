#!/bin/bash

#xinput --list
#xinput --list --long 15

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
	export MOUSE=13
	export TOUCH_PAD=14
	export TOUCH_NIPPLE=
	export TOUCH_SCREEN=
fi

export TOUCH="$TOUCH_PAD $TOUCH_NIPPLE $TOUCH_SCREEN"
