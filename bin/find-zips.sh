#!/bin/bash
# online file extension database https://fileinfo.com/extension/zip
find-code.sh $* | egrep -i '\.(7z|cab|gz|[jtw]?ar|tgz|zip)$' # tar jar war