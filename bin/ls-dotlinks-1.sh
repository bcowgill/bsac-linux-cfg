# list hidden symbolic links non-recursively
ls -al $* | grep -E '^lr' | grep -E ' \.' | perl -pne '$dir = m{/$}xms; s{\A.+?\s(\..+)}{$1}xmsg; s{(\s+->)}{/$1}xms if $dir' | perl -pne 's{\s+->.+\z}{\n}xms'
exit $?

Example output for links to files/directories
.my.cnf
.ievms/

