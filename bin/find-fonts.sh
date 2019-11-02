#!/bin/bash
# online file extension database https://fileinfo.com/extension/ttf
find-code.sh $* | egrep -i '\.(fon|fnt|ttf|woff2?)$'
