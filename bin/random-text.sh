#!/bin/bash
# choose a random fortune generating program
function choose
{
	local run
	run="$1"
	if [ -z "$CHOICE" ]; then
		perl -e 'exit 1 if rand() < 1/50; exit 0;' || CHOICE="chosen"
	fi
	if [ ! -z "$CHOICE" ]; then
		$run
		exit 0
	fi
}

function chooseN
{
	local run
	run="$1"
	if [ -z "$CHOICE" ]; then
		perl -e 'exit 1 if rand() < 0.1; exit 0;' || CHOICE="chosen"
	fi
	if [ ! -z "$CHOICE" ]; then
		$run | head -20
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

while [ -z "$CHOICE" ];
do
	pick fortune
	pick uptime
	pick who
	pick ifconfig
	pick lspci
	pick lsusb
	pick lsblk
	pick lscpu
	pick date
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

	which fortune   > /dev/null && choose "fortune -l"
	which top       > /dev/null && chooseN "top -bn1"
	which cat       > /dev/null && choose "cat `find $HOME/bin/template/text/ -type f | choose.pl`"
	which cat       > /dev/null && choose "cat `find $HOME/bin/template/unicode/ -type f | choose.pl`"
	which strings   > /dev/null && choose "strings `find /usr/bin -type f | choose.pl`"
	which df        > /dev/null && choose "df -k"
	which uname     > /dev/null && choose "uname -a"
	which stty      > /dev/null && choose "stty --all"
	which ls        > /dev/null && chooseN "ls -al"
	which ss        > /dev/null && chooseN "ss --all"
	which getfacl   > /dev/null && chooseN "getfacl ."
	which networkctl > /dev/null && chooseN "networkctl status --all"
	which fuser     > /dev/null && chooseN "fuser -l"
	which lsw       > /dev/null && chooseN "lsw -l"
	which lsx       > /dev/null && chooseN "lsx /usr/local/sbin"
	which lsx       > /dev/null && chooseN "lsx /usr/local/bin"
	which lsx       > /dev/null && chooseN "lsx /usr/local/games"
	which lsx       > /dev/null && chooseN "lsx /usr/sbin"
	which lsx       > /dev/null && chooseN "lsx /usr/bin"
	which lsx       > /dev/null && chooseN "lsx /usr/games"
	which lsx       > /dev/null && chooseN "lsx /sbin"
	which lsx       > /dev/null && chooseN "lsx /bin"
	which lsb_release > /dev/null && choose "lsb_release --all"
	which ping      > /dev/null && choose "ping -c 1 google.com"
done

