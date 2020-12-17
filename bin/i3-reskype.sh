#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# kill and relaunch skypeforlinux on the right workspace
kill -9 `pidof skypeforlinux`
sleep 1
i3-msg 'workspace 6; exec skypeforlinux'
