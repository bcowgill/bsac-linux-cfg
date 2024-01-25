#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# update the locate database on linux or mac
# see also updatedb-backup.sh locate
# see also updatedb-backup.sh locate lokate.sh updatedb

# dir_is_world_readable
# drwxr-xr--+ 37 br388313  staff      1184 24 Jan 17:32 .
if ls -al $HOME | grep ' \.$' | grep -E '^d......r.x' > /dev/null ; then
    true
else
    echo WARNING: your home directory is not world readable+executable so it will not be indexed by updatedb.
fi
which updatedb > /dev/null && sudo updatedb

# Mac is tricky and slower, 6minutes to index users dir
[ -x /usr/libexec/locate.updatedb ] && sudo /usr/libexec/locate.updatedb

ACT=load
#ACT=bootstrap
[ -d /System/Library/LaunchDaemons ] && sudo launchctl $ACT -w /System/Library/LaunchDaemons/com.apple.locate.plist
