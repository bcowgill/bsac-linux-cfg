#!/bin/bash
# kill and relaunch skype on the right workspace
killall skype
sleep 1
i3-msg 'workspace 6; exec skype'
