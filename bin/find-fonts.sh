#!/bin/bash
# online file extension database https://fileinfo.com/extension/ttf
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(fon|fnt|ttf|woff2?)$'
