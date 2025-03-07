#!/bin/bash
# Launch windows on workspaces as desired when starting up i3 window manager
# this does not require window classes to be mapped to workspaces

source detect-monitors.sh

# define vars for workspaces (updated by i3-config-update.sh)
#WORKSPACEDEF
#  do not edit settings here...
		# 1 or 2 monitors
		shell=1
		edit=2
		app=3
		email=4
		build=5
		chat=6
		vbox=7
		help=10
		files=8
#/WORKSPACEDEF

# https://github.com/lzap/doti3/blob/master/autostart
# Wait for program coming up
wait_for_program () {
	local n pid
	pid=$!
	n=0
	while true
	do
		# PID of last background command
		if xdotool search --onlyvisible --pid $pid 2>/dev/null; then
			break
		else
			if [ $n -eq 90 ]; then
				notify-send -u critical "Error during start"
				break
			else
				n=$(($n + 1))
				sleep 0.5
			fi
		fi
	done
}

function i3do {
	local msg
	msg="$1"
	echo i3-msg "$1" 1>&2
	i3-msg "$1"
}

## Merge Xresources
xrdb -merge ~/.Xresources &

## Desktop background or picture
#xsetroot -solid '#101010' &
xsetroot -mod 16 16 -bg '#000000' -fg '#ff0000'
#feh --bg-scale "$HOME/Pictures/WorkSafe/velda-dhc-photo-shoot-3.jpg" &

## Set startup volume (use pactl info to determine sink name)
#pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo '60%' &

## Load "funny" sample
#pactl upload-sample ~/.i3/that_was_easy.wav that_was_easy &
#pactl upload-sample ~/.i3/volume_blip.wav volume_blip &

## Disable beeps
xset -b &
# Display current xset settings for kb,mouse,power, etc
#xset -q

## Keybord layout setting
#setxkbmap -layout cz,us -option grp:shift_shift_toggle &

## C-A-Backspace to kill X
#setxkbmap -option terminate:ctrl_alt_bksp &

## Turns on the numlock key in X11
#numlockx on &

## Set LCD brightness
xbacklight -set 100 &

## Gamma correction through the X server
#xgamma -gamma 1.1 &

## Composite manager
#xcompmgr -cf -r 0 -D 6 &

## Applets
# clipboard manager
#LC_ALL=C parcellite &
# gnome network manager notification applet
LC_ALL=C nm-applet &

## OSD
# TODO desktop notifications, configure font
#dunst &

xscreensaver &
dropbox.sh &

if [ -e ~/i3-quick-start ]; then
	rm ~/i3-quick-start
else

# $files
i3do "workspace $files; exec browse.sh"
i3do "workspace $files; exec mygterm.sh $HOME/bin mc $HOME/bin /data/me"
sleep 5

# $app
i3do "workspace $app; exec chromium-browser"
#i3do "workspace $app; exec chromium-browser chrome-extension://edacconmaakjimmfgnblocblbcdcpbko/main.html"
sleep 2

# $build
# Layout then build workspace:
#
# .-----.-----.
# :     A     :
# :-----------:
# :     B     :
# ._____._____.
# A/B should be terminals with build/watch running
i3do "workspace $build"
xbuild-screen-upper.sh &
sleep 2
i3do "mark buildupper"

i3do "layout default; split v"
xbuild-screen-lower.sh &
sleep 1
i3do "mark buildlower"


# $shell
i3do "workspace $shell; exec git-gui.sh; exec mygterm.sh $HOME/bin"
sleep 1
i3do "mark git"

i3do "focus left"
sleep 1
i3do "mark shell"

# $chat
i3do "workspace $chat; exec skypeforlinux"
sleep 3

# scratchpad setup with a logged screen session
i3do "workspace $vbox; exec mygterm.sh ~ float.sh"
#mygterm.sh ~ float.sh
sleep 1
i3do "move scratchpad"
sleep 1

# $edit
i3do "workspace $edit; exec emacs.sh"
i3do "workspace $edit; exec warnme.sh"

fi # !i3-quick-start

random-desktop.sh

xrefresh &

## Special keys
#sleep 5s && xmodmap /home/lzap/.Xmodmap &

## Start Workrave
#workrave &

#diffmerge /home/me/bin/cfg/workshare/i3-launch.sh /home/me/bin/cfg/i3-launch.sh &

i3-dump-log > $HOME/.i3-dump.log
