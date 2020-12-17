#!/bin/bash
# fire up programs when running in a gui
#charles &
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# CUSTOM settings you may have to change on a new computer

[ ! -d /tmp/$USER ] && mkdir -p /tmp/$USER

function run_logged
{
	local log cmd
	log=$1
	cmd="${2:-$1}"
	$cmd > /tmp/$USER/$log.log 2>&1 &
}

xscreensaver -log /tmp/$USER/xscreensaver.log &
#sleep 5
run_logged wstorm
sleep 1
run_logged chromium-browser
sleep 1
run_logged firefox
sleep 1
run_logged skypeforlinux
sleep 1
run_logged gnome-terminal

pushd ~/projects/dealroom-ui
run_logged git-gui "git gui"
#grunt serve:test

# window class names:
#  xprop | grep WM_CLASS >> gui.sh
#                  instance, class
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
#WM_CLASS(STRING) = "topBox", "Xman"
#WM_CLASS(STRING) = "manualBrowser", "Xman"
