#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

git add cfg/.gconf/apps/gnome-terminal/profiles/Default/%gconf.xml
clean.sh
git checkout -- cfg/raspberrypi/etc/rc.local.orig
WORKON="wip Updated gconf.xml settings" git commit

