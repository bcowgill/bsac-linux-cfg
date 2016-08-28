#!/bin/bash

#xinput --list
#xinput --list --long 15

export MOUSE=
export TOUCH_PAD=15
export TOUCH_NIPPLE=
export TOUCH_SCREEN=13

if [ $HOSTNAME == "akston" ]; then
	export MOUSE=11
	export TOUCH_PAD=12
	export TOUCH_NIPPLE=14
	export TOUCH_SCREEN=
fi

export TOUCH="$TOUCH_PAD $TOUCH_NIPPLE $TOUCH_SCREEN"
