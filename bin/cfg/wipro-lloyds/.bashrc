# .bashrc

if [ -f ~/oh-my-git-aliases.sh ]; then
    . ~/oh-my-git-aliases.sh
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Instead of all these settings, just create a HOME C:\d\home setting in My Computer Environment Settings
#export HOME=/c/d/home
#export HOMEDRIVE=C:
#export HOMEPATH='\d\home'
#export HOMESHARE=
#export HISTFILE=$HOME/.bash_history

export U=/c/Users/9303163
export PATH=$HOME/bin/cfg/wipro-lloyds:$HOME/bin:$PATH:/c/Program\ Files/Sublime\ Text\ 2:/c/Program\ Files/KDiff3:$U/AppData/Local/atom:./node_modules/.bin
export REPOS="
card-servicing
"

export COMPANY=lloyds

export EDITOR=/bin/vim

# Windows Drive Maps
# O: \\Global.lloydstsb.com\HOME\PET08\9303163
# S: \\Global.lloydstsb.com\file\D_GALAXY0001$\Shared
# T: \\Global.lloydstsb.com\file2\DML\SHARED\DigitalDevTools

#PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\w$(__git_ps1)\[\033[0m\]\n$'
