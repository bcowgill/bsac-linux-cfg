#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# update CD scan files
( cd $HOME;
    find . -type d -print | sed -e "s;^\.;$HOME;" | sort -u > $HOME/.cdpaths ) &
echo WCDSCAN=$WCDSCAN
wcd.exec -z 50 -s


