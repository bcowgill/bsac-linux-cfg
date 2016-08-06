#!/bin/bash
feh --bg-scale "`find $HOME/Pictures/WorkSafe/ -type f | egrep -i '\.(jpe?g|png|gif|bmp)' | choose.pl`"
