#!/bin/bash
# adjust brightness up or down

file="/sys/class/backlight/intel_backlight/brightness"
level=$(cat $file)

INC=528
if [[ "$#" -eq 0 ]]; then
    cat $file
elif [[ "$1" = "-" ]]; then
    echo $(( level - $INC )) > $file
    cat $file
elif [[ "$1" = "+" ]]; then
    echo $(( level + $INC )) > $file
    cat $file
fi
