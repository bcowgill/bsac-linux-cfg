# list hidden files non-recursively
ls -al $* | grep -vE '^[dl]r' | grep -E ' \.' | perl -pne 's{\A.+?\s(\..+)}{$1}xmsg'
exit $?

Example output for files
.env
