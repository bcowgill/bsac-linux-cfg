#!/bin/bash
# cross-platform play an OK sound

SOUND=${1:-$HOME/bin/sounds/laser.wav}
sound-play.sh "$SOUND"
