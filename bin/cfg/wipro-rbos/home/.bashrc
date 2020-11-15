# .bashrc (windows + git bash version)

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# CUSTOM settings to change on a new machine.
export COMPANY=rbos
export EDITOR=/bin/vim

export OFFICE=""
export VSCODE=""
export WINMERGE=""
export ATOM="$U/AppData/Local/atom"
export SUBL="/c/Program Files/Sublime Text 2"
export KDIFF="/c/Program Files/KDiff3"

EDIT="$SUBL"
DIFF="$KDIFF"

# Instead of all these settings, just create a HOME C:\d\home setting in My Computer Environment Settings
#export HOME=/c/d/home
#export HOMEDRIVE=C:
#export HOMEPATH='\d\home'
#export HOMESHARE=
#export HISTFILE=$HOME/.bash_history

# CUSTOM configuration on a new machine.
export U=/c/Users/9303163
export PATH="$HOME/bin/cfg/wipro-$COMPANY:$HOME/bin:$PATH:$EDIT:$DIFF:$ATOM:$OFFICE:./node_modules/.bin:./scripts"
export REPOS="
card-servicing
"

# Windows Drive Maps
# O: \\Global.lloydstsb.com\HOME\PET08\9303163
# S: \\Global.lloydstsb.com\file\D_GALAXY0001$\Shared
# T: \\Global.lloydstsb.com\file2\DML\SHARED\DigitalDevTools

#PS1='\[\033]0;$MSYSTEM:${PWD//[^[:ascii:]]/?}\007\]\n\[\033[32m\]\u@\h \[\033[33m\]\w$(__git_ps1)\[\033[0m\]\n$'
