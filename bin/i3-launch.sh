#!/bin/bash
# Launch windows on workspaces as desired when starting up i3 window manager
# this does not require window classes to be mapped to workspaces
# TODO should use the $shell and other vars from i3-config if possible
# instead of hard coded here

# $files
i3-msg "workspace 8; exec mygterm.sh $HOME/projects/dealroom-ui mc $HOME/projects/dealroom-ui $HOME"
sleep 1
# $email
xscreensaver &
i3-msg 'workspace 7; exec xscreensaver-demo' # placeholder to lock screen
sleep 1
# $help
i3-msg 'workspace 4; exec chromium-browser --incognito http://google.co.uk' # just a placeholder until something useful needed
sleep 1
# $app
i3-msg 'workspace 3; exec chromium-browser'
sleep 1

# $build

# This one just will not layout how I like it:
#
# .-----.-----.
# :  A  :     :
# :-----:  C  :
# :  B  :     :
# ._____._____.
# A/B should be terminals with build/watch running
# C should be browser
# I have default workspaces set to Tabbed
# I can get this arrangement manually with the following key/commands:
# launch terminal, launch terminal, Mod+e, Mod+e -- puts two terminals on top of each other
# Mod+a, Mod+e, launch browser -- focus parent, default layout makes browser go beside the terminal pair
# tried to replicate these commands with i3-msg as below. Just ends up with three tabbed windows.
# To make the layout work from the three tabbed windows:
# Click Window A Mod+e Mod+e, Click Window C Mod+Shift+;
i3-msg 'workspace 5; exec xbuild-deal.sh; exec xbuild-newui.sh; exec firefox'
#i3-msg 'workspace 5; exec xterm; exec xterm; layout default; layout toggle split; layout toggle split; layout splith; focus parent; layout splitv; exec firefox'
sleep 2

# $edit
i3-msg 'workspace 2; exec wstorm'
sleep 17

# $shell
i3-msg "workspace 1; exec git-gui.sh; exec mygterm.sh $HOME/bin"
sleep 1

# $chat
i3-msg 'workspace 6; exec skype'
sleep 3


