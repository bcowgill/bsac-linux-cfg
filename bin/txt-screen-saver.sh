#!/bin/bash
# a text mode screen saver for use with the screen program

function choose
{
	local run
	run="$1"
	if [ -z "$CHOICE" ]; then
		perl -e 'exit 1 if rand() < 0.1; exit 0;' || CHOICE="$run"
	fi
}

CHOICE=""
while [ -z "$CHOICE" ];
do
	which linuxlogo > /dev/null && choose "logo-screen-saver.sh"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C red"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C white"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C blue"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C green"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C yellow"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C cyan"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C magenta"
	which cmatrix   > /dev/null && choose "cmatrix -b -s -C black"
	which cacafire  > /dev/null && choose "cacafire"
	which cacademo  > /dev/null && choose "cacademo"
	which cacaclock > /dev/null && choose "cacaclock"
done
$CHOICE
