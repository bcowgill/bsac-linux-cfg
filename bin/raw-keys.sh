#!/bin/bash
# show raw key codes - must be on a console, not Xterm or network login
# https://wiki.archlinux.org/index.php/Extra_keyboard_keys

LOG=raw-keys.log

function trapped
{
	echo TRAPPED SIGINT
	trap SIGINT # restore trap to original handler
}

clear
sleep 1
set -x
showkey --scancodes
if [ $? == 0 ]; then
	showkey --keycodes
	showkey --ascii
	sudo screendump | perl -pne 's{\A \s+}{}xmsg' > $LOG
else
	# http://stackoverflow.com/questions/24848843/how-do-i-stop-a-signal-from-killing-my-bash-script/24849226#24849226
	set +x
	trap -- trapped SIGINT
	set -x
	sudo evtest | tee $LOG
fi

set +x

(\
	echo checking dmesg for unknown keys; \
	dmesg | egrep -i 'unknown key' ) | tee --append $LOG

