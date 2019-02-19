#!/bin/bash
# save ~/ files from git shell on Lloyds laptop to ~/bin/cfg/... for safety

WHOM=lloyds
WHERE=wipro-lloyds
if [ "$COMPANY" == "$WHOM" ]; then
	echo Saving $COMPANY config to ~/bin/cfg/$WHERE
else
	echo This script is only for use on $WHOM computer.
	exit 1
fi

pushd ~/bin/cfg/$WHERE
	mkdir -p .config/git
	mkdir -p home
	cp ~/.bashrc .
	cp ~/.bash_profile .
	cp ~/.bash_aliases .
	cp ~/.bash_functions .
	cp ~/.gitconfig .
	cp ~/.gitk .
	cp ~/.config/git/gitk .config/git/gitk
	cp ~/.lesshst .
	cp ~/.minttyrc .
	cp ~/.viminfo .
	cp ~/*.sh home/
	cp ~/readme.txt home/
popd

