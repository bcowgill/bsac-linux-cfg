#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
feh --bg-scale "`find $HOME/Pictures/WorkSafe/ -type f | egrep -i '\.(jpe?g|png|gif|bmp)' | choose.pl`"
