#!/bin/bash
# fire up programs when running in a gui
#charles &
#sleep 5
wstorm &
sleep 1
chromium-browser &
sleep 1
firefox &
sleep 1
skype &
sleep 1
gnome-terminal&

pushd ~/projects/dealroom-ui
git gui &
#grunt serve:test

# window class names: 
#  xprop | grep WM_CLASS >> gui.sh
#WM_CLASS(STRING) = "skype", "Skype"
#WM_CLASS(STRING) = "git-gui", "Git-gui"
#WM_CLASS(STRING) = "sun-awt-X11-XFramePeer", "jetbrains-webstorm"
#WM_CLASS(STRING) = "Chromium-browser", "Chromium-browser"
#WM_CLASS(STRING) = "gnome-terminal-server", "Gnome-terminal"
#WM_CLASS(STRING) = "xterm", "XTerm"
#WM_CLASS(STRING) = "konsole", "konsole"
#WM_CLASS(STRING) = "ksnapshot", "Ksnapshot"
#WM_CLASS(STRING) = "diffmerge", "Diffmerge"
#WM_CLASS(STRING) = "Navigator", "Firefox"
#WM_CLASS(STRING) = "nautilus", "Nautilus"
# system settings app
#WM_CLASS(STRING) = "unity-control-center", "Unity-control-center"

