#!/bin/bash
# kill and relaunch skypeforlinux on the right workspace
kill -9 `pidof skypeforlinux`
sleep 1
i3-msg 'workspace 6; exec skypeforlinux'
