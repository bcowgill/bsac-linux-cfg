#!/bin/bash
# kill and relaunch skype on the right workspace
kill -9 `pidof skype`
sleep 1
i3-msg 'workspace 6; exec skype'
