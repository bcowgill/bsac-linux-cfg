#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/md
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '(readme|\.(man|m[de]|u?txt|utf-?8))$' # .man .md .me .txt .utxt .utf8 .utf-8
