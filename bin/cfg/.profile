# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

#echo `date` .profile >> ~/startup.log

if [ "$TERM" == "linux" ]; then
    # make linux console font larger due to high resolution
    /bin/setfont /usr/share/consolefonts/Uni1-VGA32x16.psf.gz
    #/bin/setfont /usr/share/consolefonts/Uni2-Terminus28x14.psf.gz
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    echo $PATH | grep "$HOME/bin:" > /dev/null || PATH="$HOME/bin:$PATH"
fi
