#!/bin/bash
# resetting a wonky terminal
# https://www.baeldung.com/linux/reset-terminal-screen-issues

echo stty --all:
stty --all  # show your terminal settings
echo " "

echo 'Ctrl-l  clears the terminal screen
Ctrl-U  (stty: kill) clears text to left of cursor
Ctrl-/  (bash?) undo last bunch of typing
Ctrl-W  (stty: werase) erase word to left of cursor
Ctrl-?  (stty: erase) backspace. erase the last character typed
or Ctrl-Shift-?  (stty: erase) backspace. erase the last character typed
Ctrl-V  (stty: lnext) show next typed character literally like Ctrl-V Ctrl-C will show ^C instead of breaking.
Ctrl-Alt-F1 .. F6 switch to virtual console terminal 1-6
Ctrl-Alt-F7 switch to virtual terminal 7 running the GUI (i3wm)
'

# Reset without clearing the screen

# stty sane does not clear the screen but restores the terminal’s line editing and echoing behavior. This feature makes it ideal for fixing specific input or display issues without reinitializing the entire terminal.

echo 'stty sane   / reset terminal line editing and echoing but does not clear the screen'

# the tput init command performs a soft reset, which restores the terminal’s default settings without clearing the screen:

echo 'tput init   / soft reset to default settings without clearing the screen'

# Reset and clear the screen

# When we execute the reset command, it reinitializes terminal settings, fixing issues such as garbled output and unresponsive behavior. Moreover, the reset command doesn’t affect running processes or stored data.

echo 'reset       / reinitializes terminal settings fix garbled output and unreseponsive behaviour'

# if that fails...

# The command relies on the terminal’s internal database to determine the correct reset sequence. This makes it more effective at resetting the terminal to its default state, especially where the standalone reset command is not working as expected.

echo 'tput reset  / reset terminal to default when reset command fails'

exit $?

Example of stty -a output in floating terminal window in i3wm:

speed 38400 baud; rows 31; columns 79; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts
-ignbrk brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon -ixoff
-iuclc -ixany imaxbel -iutf8
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt
echoctl echoke

===

Example of stty -a output in full screen terminal window in i3wm:

speed 38400 baud; rows 43; columns 159; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = M-^?; eol2 = M-^?; swtch = M-^?; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R; werase = ^W;
lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts
-ignbrk brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon -ixoff -iuclc ixany imaxbel iutf8
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke

===

Example of stty -a output in full screen console terminal window Ctrl-Alt-F1:

speed 38400 baud; rows 38; columns 137; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>; eol2 = <undef>; swtch = <undef>; start = ^Q; stop = ^S; susp = ^Z;
rprnt = ^R; werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread -clocal -crtscts
-ignbrk brkint ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl ixon -ixoff -iuclc -ixany imaxbel iutf8
opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0 vt0 ff0
isig icanon iexten echo echoe echok -echonl -noflsh -xcase -tostop -echoprt echoctl echoke
