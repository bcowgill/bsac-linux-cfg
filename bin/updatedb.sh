#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# update the locate database on linux or mac
# see also updatedb-backup.sh locate
# see also updatedb-backup.sh locate lokate.sh updatedb

date
# drwxr-xr--+ 37 br388313  staff      1184 24 Jan 17:32 .
if ls -al $HOME | grep ' \.$' | grep -E '^d......r' > /dev/null ; then
    true
else
    echo WARNING: your home directory is not world readable so it will not be indexed by updatedb.
fi
which updatedb > /dev/null && sudo updatedb
date
# Mac is tricky
[ -x /usr/libexec/locate.updatedb ] && sudo /usr/libexec/locate.updatedb
date
[ -d /System/Library/LaunchDaemons ] && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
date
