# list hidden files non-recursively
ls -al $* | grep -E ' \.' | perl -pne '$dir = m{\Ad}xms; $dirlink = m{/$}xms; s{\A.+?\s(\..+)}{$1}xmsg; s{\n}{/\n}xms if $dir; s{(\s+->)}{/$1}xms if $dirlink' | grep -vE '^\.\.?/$'
exit $?

Example output for files, directories and links to files/directories
.lesshst
.local/
.my.cnf -> bin/cfg/.my.cnf
.ievms/ -> /data/bcowgill/VirtualBox/ie-vm-downloads/

