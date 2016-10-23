#!/bin/bash
# Display warnings from warning log if anything there
WARN=$HOME/warnings.log
if perl -ne 'exit(1) if m{\S}xms' $WARN 2> /dev/null; then
	exit 0
else
	cat $WARN
	xedit $WARN &
	which notify > /dev/null && notify -t $HOME/warnings.log < $HOME/warnings.log
	exit 1
fi
