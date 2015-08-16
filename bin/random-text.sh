#!/bin/bash
# choose a random fortune generating program

END=
LINES=15
RATIO_TEXT=0.8
RATE_SYSTEM="1/40"

function pick_mode
{
	MODE=system
	perl -e "exit 1 if rand() < $RATIO_TEXT; exit 0;" || MODE="text"
}

function roll
{
	if [ -z "$CHOICE" ]; then
		perl -e "exit 1 if rand() < $RATE_SYSTEM; exit 0;" || CHOICE="chosen"
	fi
}

function choose
{
	local run
	run="$1"
	roll
	if [ ! -z "$CHOICE" ]; then
		#echo chose "$run"
		$run
		echo $END
		exit 0
	fi
}

function chooseN
{
	local run
	run="$1"
	roll
	if [ ! -z "$CHOICE" ]; then
		#echo chose "$run"
		$run | choose.pl $LINES
		echo $END
		exit 0
	fi
}

function pick
{
	local run
	run="$1"

	which $run > /dev/null && choose "$run"
}

function pickN
{
	local run
	run="$1"

	which $run > /dev/null && chooseN "$run"
}

#CHOICE=chosen
#cat $HOME/bin/template/text/starwars/starwars-episode-iv.wrapped.txt

pick_mode

while [ -z "$CHOICE" ];
do
	if [ $MODE == text ]; then
		pick fortune
		which fortune   > /dev/null && choose "fortune -l"
		which cat       > /dev/null && choose "cat `find $HOME/bin/template/text/starwars/ -type f | choose.pl`"
		which cat       > /dev/null && chooseN "cat `find $HOME/bin/template/unicode/ -type f | choose.pl`"
		which man       > /dev/null && chooseN "man `ls -1 /usr/local/sbin/ /usr/local/bin/ /usr/sbin/ /sbin/ /bin/ /usr/games/ /usr/local/games | choose.pl`"
		which man       > /dev/null && chooseN "man -k `choose.pl < /usr/share/dict/words`"
		chooseN "cat `ls /usr/share/dict/*-english | choose.pl`"
	else
		pick date
		pick uptime
		pick who
		pick ifconfig
		pickN lspci
		pick lsusb
		pick lsblk
		pick lscpu
		pick networkctl
		pickN vdir
		pickN lsattr
		pickN lshw
		pickN lslocks
		pickN lsmod
		pickN dmesg
		pickN netstat
		pickN xlsfonts
		pickN du-sk.sh
		pickN ls-fonts.sh
		pick what-apps.sh

		which top       > /dev/null && chooseN "top -bn1"
		which lsb_release > /dev/null && choose "lsb_release --all"
		which strings   > /dev/null && chooseN "strings `find /usr/bin -type f | choose.pl`"
		which df        > /dev/null && choose "df -k"
		which uname     > /dev/null && choose "uname -a"
		which stty      > /dev/null && choose "stty --all"
		which ls        > /dev/null && chooseN "ls -al"
		which ss        > /dev/null && chooseN "ss --all"
		which locale    > /dev/null && choose "locale -a"
		which getfacl   > /dev/null && chooseN "getfacl ."
		which networkctl > /dev/null && chooseN "networkctl status --all"
		which fuser     > /dev/null && chooseN "fuser -l"
		which lsw       > /dev/null && chooseN "lsw -l"
		which lsx       > /dev/null && chooseN "lsx /usr/local/bin"
		which lsx       > /dev/null && chooseN "lsx /usr/sbin"
		which lsx       > /dev/null && chooseN "lsx /usr/bin"
		which lsx       > /dev/null && chooseN "lsx /usr/games"
		which lsx       > /dev/null && chooseN "lsx /sbin"
		which lsx       > /dev/null && chooseN "lsx /bin"
		which ping      > /dev/null && choose "ping -c 1 google.com"
	fi
done

