# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

echo === `date` debug-shell:.bash_logout entered ========================= >> ~/startup.log
echo `date` debug-shell: HOSTNAME: $HOSTNAME TYPE: $MACHTYPE $HOSTTYPE $OSTYPE LOGNAME: $LOGNAME USER: $USER HOME: $HOME >> ~/startup.log
echo `date` debug-shell: DISPLAY: $DISPLAY TERM: $TERM LANG: $LANG TZ: $TZ PWD: $PWD >> ~/startup.log
echo `date` debug-shell: SHLVL: $SHLVL -: $- UID: $UID EUID: $EUID PPID: $PPID WINDOWID: $WINDOWID COL: $COLUMNS LINES: $LINES $BASH $BASH_VERSION >> ~/startup.log
echo `date` debug-shell: PATH: $PATH >> ~/startup.log

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi
