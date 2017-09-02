#!/bin/bash
# play a sound file

CARD=1
SOUND=${1:-$HOME/bin/sounds/laser.wav}
aplay -D sysdefault:CARD=PCH "$SOUND"
