# list hidden directories non-recursively
ls -al $* | grep -E '^dr' | grep -E ' \.' | perl -pne 's{\A.+?\s(\..+)}{$1}xmsg; s{\n}{/\n}xms' | grep -vE '^\.\.?/$'
exit $?

Example output for directories
.local/

