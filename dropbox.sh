#!/bin/bash
# start up dropbox daemon - shouldn't need to as kde autostart is configured to do it.
~/workspace/dropbox-dist/.dropbox-dist/dropboxd > /tmp/dropbox.log 2>&1 &
