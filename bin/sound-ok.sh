#!/bin/bash
# cross-platform play an OK sound

SOUND=${1:-$HOME/bin/sounds/volume_blip.wav}
sound-play.sh "$SOUND"
