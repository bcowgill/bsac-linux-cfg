#!/bin/bash
# online file extension database https://fileinfo.com/extension/md
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '(readme|\.(man|m[de]|u?txt|utf-?8))$' # md
