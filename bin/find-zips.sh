#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# online file extension database https://fileinfo.com/extension/zip
# WINDEV tool useful on windows development machine
find-code.sh $* | egrep -i '\.(7z|cab|gz|[jtw]?ar|tgz|zip)$' # tar jar war
