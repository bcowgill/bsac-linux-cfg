#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# update the locate database on linux or mac
which updatedb > /dev/null && sudo updatedb
[ -x /usr/libexec/locate.updatedb ] && sudo /usr/libexec/locate.updatedb
[ -d /System/Library/LaunchDaemons ] && sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

