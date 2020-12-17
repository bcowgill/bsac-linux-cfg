#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# start up dropbox daemon - shouldn't need to as kde autostart is configured to do it.
[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER
~/workspace/dropbox-dist/.dropbox-dist/dropboxd > /tmp/$USER/dropbox.log 2>&1 &
