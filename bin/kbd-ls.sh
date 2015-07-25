#!/bin/bash
# show info about your keyboard
xmodmap -pm
xmodmap -pke

# useful to see what events a key sends:
#xev -rv -event keyboard
