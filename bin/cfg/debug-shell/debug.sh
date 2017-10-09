#!/bin/bash
# save your .bash config files and install debug versions.
HERE=`pwd`
BACKUP=bash-config.tgz

if [ -e $BACKUP ]; then
	echo NOT OK there is already a backup of your bash configuration $BACKUP
	exit 1
fi

pushd ~
	tar cvzf $HERE/$BACKUP .bash* && rm .bash* && cp $HERE/.bash* .
popd

echo OK your .bash configs have been stored in $HERE/$BACKUP and debug versions have been installed in $HOME
