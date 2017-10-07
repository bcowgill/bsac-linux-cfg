#!/bin/bash
# set sound level cross-platform and play a blip

CARD=1
LEVEL=${1:-0%}
SOUND=${2:-$HOME/bin/sounds/laser.wav}
amixer -c $CARD -- sset Master playback $LEVEL
aplay -D sysdefault:CARD=PCH $SOUND
