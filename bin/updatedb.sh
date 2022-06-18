#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# update the locate database on linux or mac
# see also updatedb-backup.sh locate
# see also updatedb-backup.sh locate lokate.sh updatedb
which updatedb > /dev/null && sudo updatedb
[ -x /usr/libexec/locate.updatedb ] && sudo /usr/libexec/locate.updatedb
[ -d /System/Library/LaunchDaemons ] && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

