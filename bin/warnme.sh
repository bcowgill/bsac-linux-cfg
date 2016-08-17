#!/bin/bash
# Display warnings from warning log if anything there
WARN=$HOME/warnings.log
if [ `cat $WARN 2> /dev/null | wc -l` != 0 ]; then
	cat $WARN
	xedit $WARN &
	which notify > /dev/null && notify -t $HOME/warnings.log < $HOME/warnings.log
	exit 1
fi
exit 0
