#!/bin/bash
# restore your .bash config files.
HERE=`pwd`
BACKUP=bash-config.tgz

if [ ! -e $BACKUP ]; then
	echo NOT OK there is no backup of your bash configuration $BACKUP to restore.
	exit 1
fi

pushd ~
	rm .bash* ; tar xvzf $HERE/$BACKUP
popd

echo OK your .bash configs have been restored from $HERE/$BACKUP
