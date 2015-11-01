#!/bin/bash
# watch for key events and show info
echo use -root option to watch root window key events
sleep 1
xev $* | egrep -A 6 'KeymapNotify|KeyPress|KeyRelease'
