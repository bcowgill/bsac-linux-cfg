# update the locate database on linux or mac
which updatedb > /dev/null && sudo updatedb
[ -x /usr/libexec/locate.updatedb ] && sudo /usr/libexec/locate.updatedb
