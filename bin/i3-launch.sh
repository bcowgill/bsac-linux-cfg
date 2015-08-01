#!/bin/bash
# Launch windows on workspaces as desired when starting up i3 window manager
# this does not require window classes to be mapped to workspaces

# TODO should use the $shell and other vars from i3-config if possible
# instead of hard coded here
shell=1
edit=2
app=3
email=4
build=5
chat=6
help=7
files=8

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

# $files
i3-msg "workspace $file; exec mygterm.sh $HOME/projects/dealroom-ui mc $HOME/projects/dealroom-ui $HOME"
sleep 1
# $help
xscreensaver &
sleep 1
i3-msg "workspace $help; exec xscreensaver-demo" # placeholder to lock screen
sleep 1
# $email
#i3-msg "workspace $email; exec chromium-browser --incognito http://google.co.uk" # just a placeholder until something useful needed
sleep 1
# $app
i3-msg "workspace $app; exec chromium-browser"
sleep 1

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
xbuild-deal.sh &
sleep 1
i3-msg "layout default; split v"
xbuild-newui.sh &
sleep 1
i3-msg "focus parent; split h"
firefox &
sleep 2

# $edit
i3-msg "workspace $edit; exec wstorm"
sleep 17

# $shell
i3-msg "workspace $shell; exec git-gui.sh; exec mygterm.sh $HOME/bin"
sleep 1
i3-msg "focus left"
sleep 1

# $chat
i3-msg "workspace $chat; exec skype"
sleep 3


