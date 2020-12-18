#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# recapture a vim session you have lost.
# https://vi.stackexchange.com/questions/5354/how-do-i-close-vim-externally

PID=$1
cmd=$(basename $0)

if [ -z "$PID" ]; then
	ps -ef | grep vim | grep -v grep | grep -v $cmd
	echo " "
	echo You can recover a lost vim session from the above list to save and exit by issuing the command:
	echo $cmd PID
	echo "

In future you can start the vim server to make it easier to save and exit.

vim --servername vim

and then see which vim servers are running:

vim --serverlist

and finally cause a specific vim server to save and exit:

vim --servername vim2 --remote-expr 'execute("wqa")'
vim --servername vim2 --remote-send $'\e:wqa\n'

The first one shows any error messages (like no file name.)
"
	exit 0
fi

echo "
======================================================================
Trying to bring vim session at PID $PID to this tty...

If it gives Permission denied error you will have to change a setting as root...

echo 0 > /proc/sys/kernel/yama/ptrace_scope
exit

# then you may have to press Enter to see the vim session.
"
reptyr $PID || (sudo su -; reptyr $PID)
