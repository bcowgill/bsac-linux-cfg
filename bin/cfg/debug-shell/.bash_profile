echo === `date` debug-shell:.bash_profile entered ========================= >> ~/startup.log
echo `date` debug-shell: HOSTNAME: $HOSTNAME TYPE: $MACHTYPE $HOSTTYPE $OSTYPE LOGNAME: $LOGNAME USER: $USER HOME: $HOME >> ~/startup.log
echo `date` debug-shell: DISPLAY: $DISPLAY TERM: $TERM LANG: $LANG TZ: $TZ PWD: $PWD >> ~/startup.log
echo `date` debug-shell: SHLVL: $SHLVL -: $- UID: $UID EUID: $EUID PPID: $PPID WINDOWID: $WINDOWID COL: $COLUMNS LINES: $LINES $BASH $BASH_VERSION >> ~/startup.log
echo `date` debug-shell: PATH: $PATH >> ~/startup.log

# grabbed from .profile file.
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        echo `date` debug-shell:.bash_profile kickoff .bashrc >> ~/startup.log
        . "$HOME/.bashrc"
    fi
fi

