#!/bin/bash
# use a banner program to print something bigger than usual
# MUSTDO help --add is needed.
# --list to list all fonts
# FONT= var to specify a font to use

function say {
	local MSG
	MSG="$*"
	if which toilet > /dev/null; then
		if [ -z "$FONT" ]; then
			FONT=pagga
		fi
		echo " "
		toilet -f $FONT "$MSG"
		echo " "
	elif which figlet > /dev/null; then
		if [ -z "$FONT" ]; then
			FONT=smslant
		fi
		figlet -f $FONT "$MSG"
		echo " "
	elif which banner > /dev/null; then
		echo " "
		banner "$MSG"
	else
		echo "$MSG"
	fi
}

TXT=${TXT:-AaBb0123}
SHOWN=
if [ "$1" == "--list" ]; then
	BAN=toilet
	if which $BAN > /dev/null; then
		SHOWN=toilet
		if which figlet > /dev/null; then
			SHOWN=toilet/figlet
		fi
		for F in `ls /usr/share/figlet/ | grep -vE '.flc$'`
		do
			#echo $F>>font.log
			#if $BAN -f $F test 2>>font.log > /dev/null; then
			if $BAN -f $F test 2> /dev/null > /dev/null; then
				echo "$SHOWN -f $F"
				$BAN -f $F "$TXT"
			fi
		done
		SHOWN=toilet
	fi
	BAN=figlet
	if which $BAN > /dev/null; then
		if [ "$SHOWN" != toilet ]; then
			for F in `ls /usr/share/figlet/`
			do
				#echo $F>>font.log
				#if $BAN -f $F test 2>>font.log > /dev/null; then
				if $BAN -f $F test 2> /dev/null > /dev/null; then
					echo "$BAN -f $F"
					$BAN -f $F "$TXT"
				fi
			done
		fi
	fi
	BAN=banner
	if which $BAN > /dev/null; then
		echo "$BAN"
		banner "$TXT"
	fi
else
	say $*
fi
