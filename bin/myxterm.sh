#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# starts a cross-platform xterm with a command to run.
# Also sets the window title and class to match the command name

if [ -e /Applications ]; then
	open -a /Applications/Utilities/Terminal.app $*
	exit 0
fi

# font family (-fa), font size (-fs)
# reverse video (-rv), NOT show tool bar (-tb), set cursor to box (+uc), blink cursor (-bc), visual bell (-vb), sun/PC keyboard codes (-sp)
# allow jump scroll (-j), Titled build (-T), class name XTermBuild
if [ -z $1 ]; then
	exec=
else
	exec=-e
fi
xterm -fa ProFontWindows -fs 18 -rv +uc -bc -vb -sp -j -T $1 -class $1 $exec $* &
#-report-fonts -report-colors
