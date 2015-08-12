#!/bin/bash
# kill and relaunch skype on the right workspace
kill -9 `ps -ef | grep skype | egrep -v 'grep|/bin/' | perl -pne '@F=split(/\s+/); $_ = qq{$F[1]\n}'`
sleep 1
i3-msg 'workspace 6; exec skype'
