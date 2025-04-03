#!/bin/bash

function say {
	local MSG
	MSG="$*"
	if which toilet > /dev/null; then
		echo " "
		toilet -f pagga "$MSG"
		echo " "
	elif which figlet > /dev/null; then
		figlet -f smslant "$MSG"
		echo " "
	elif which banner > /dev/null; then
		echo " "
		banner "$MSG"
	else
		echo "$MSG"
	fi
}

say $*
