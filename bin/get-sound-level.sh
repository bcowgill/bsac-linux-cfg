#!/bin/bash
# get current master sound level
CARD=1

#   Mono: Playback 84 [97%] [-2.25dB] [on]
amixer -c $CARD -- sget Master playback | perl -ne 'if (m{\[(\d+\%)\]}xms) { print qq{$1\n}}'
