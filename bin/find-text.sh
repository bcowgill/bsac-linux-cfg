#!/bin/bash
# online file extension database https://fileinfo.com/extension/md
find-code.sh $* | egrep -i '(readme|\.(man|m[de]|u?txt|utf-?8))$' # 


