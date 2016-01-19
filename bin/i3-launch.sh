#!/bin/bash
# Launch windows on workspaces as desired when starting up i3 window manager
# this does not require window classes to be mapped to workspaces

WSBIN=$HOME/bin/workshare
export PATH=$WSBIN:$PATH

# define vars for workspaces (updated by i3-config-update.sh)
#WORKSPACEDEF
#  do not edit settings here...
		shell=1
		edit=2
		app=3
		email=4
		build=5
		chat=6
		vbox=7
		help=7
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

## Merge Xresources
xrdb -merge ~/.Xresources &

## Desktop background or picture
#xsetroot -solid '#101010' &
xsetroot -mod 16 16 -bg '#000000' -fg '#ff0000'
#feh --bg-scale "$HOME/Dropbox/WorkSafe/velda-dhc-photo-shoot-3.jpg" &

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

## Disable monitor power management
xset -dpms &
## DPMS monitor setting (standby -> suspend -> off) (seconds)
#xset dpms 600 1200 2000 &

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

# $help
i3-msg "workspace $help; exec ebook.sh"
sleep 15

# $files
i3-msg "workspace $files; exec browse.sh"
i3-msg "workspace $files; exec mygterm.sh $HOME/projects/new-ui mc $HOME/projects/new-ui $HOME"
sleep 5

# $vbox
#i3-msg "workspace $vbox; exec xscreensaver-demo" # placeholder to lock screen
i3-msg "workspace $vbox; exec virtualbox"
sleep 2

# $email
i3-msg "workspace $email; exec i3-sensible-terminal" # placeholder for google chrome
sleep 1

# $app
i3-msg "workspace $app; exec chromium-browser"
sleep 2

# $build
# Layout then build and tomato timer workspace:
#
# .-----.-----.
# :  A  :     :
# :-----:  C  :
# :  B  :     :
# ._____._____.
# A/B should be terminals with build/watch running
# C should be browser
i3-msg workspace $build
xbuild-files.sh &
sleep 2
i3-msg mark watch

i3-msg "layout default; split v"
xbuild-newui.sh &
sleep 1
i3-msg mark newui

i3-msg "focus parent; split h"
firefox &
sleep 2
i3-msg mark tomato

# $shell
i3-msg "workspace $shell; exec git-gui.sh; exec mygterm.sh $HOME/bin"
sleep 1
i3-msg mark git

i3-msg "focus left"
sleep 1
i3-msg mark shell

# $chat
i3-msg "workspace $chat; exec skype"
sleep 3

# scratchpad setup with a terminal
mygterm.sh
sleep 1
i3-msg "move scratchpad"

# $edit
i3-msg "workspace $edit; exec wstorm.sh"

random-desktop.sh

xrefresh &

## Special keys
#sleep 5s && xmodmap /home/lzap/.Xmodmap &

## Start Workrave
#workrave &
