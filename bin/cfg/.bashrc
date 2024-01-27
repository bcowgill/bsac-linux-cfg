# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#echo `date` .bashrc >> ~/startup.log

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# BSAC turned color prompt on
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1_SHORT='${debian_chroot:+($debian_chroot)}:\[\033[01;34m\]\W\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1_SHORT='${debian_chroot:+($debian_chroot)}\w\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
# BSAC disable here as we mess with PS1 later
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1_SHORT="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \W\a\]$PS1_SHORT"
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Git configuration.
if [ -f ~/.git_aliases ]; then
    . ~/.git_aliases
fi

if command -V __git_ps1 > /dev/null 2> /dev/null; then
	true
else
	. ~/bin/cfg/git-sh-prompt
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
if which sw_vers > /dev/null 2>&1 ; then
  # bash completion on MACOS
  [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
fi

# enable completion with the npm command if it hasn't been done by bash_completion above
if [ -f ~/.npm_completion ]; then
	# create the completion file with:
	# npm completion > ~/.npm_completion
	. ~/.npm_completion
fi

#==========================================================================
# BSAC custom changes from /etc/skel

COMPANY=
if [ -f ~/.COMPANY ]; then
    . ~/.COMPANY
fi
export COMPANY

if [ "x$COMPANY" == "xclearbooks" ]; then
	export PJ=$HOME/projects
	export REPOS="clearbooks-micro-api-accounting  clearbooks-micro-api-auth  clearbooks-micro-front"
fi

if [ "x$COMPANY" == "xworkshare" ]; then
	export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
	export PJ=$HOME/projects
	export REPOS="core-ui files-ui groups-ui dealroom-ui new-ui"
fi

if [ "x$COMPANY" == "xwipro" ]; then
  export PJ=$HOME/workspace/projects:./node_modules/.bin
  export MAS=sprint0/trunk
  export REPOS="
  	pas-card-control-api
  	pas-card-control-api-ucd-deploy
  	pas-card-control-mock
  	pas-card-control-visa-adapter
  	pas-card-controls-cwa
  	pas-card-controls-cwa-ucd-deploy
  "
fi

export PATH=$HOME/bin:$PATH:./node_modules/.bin
export EDITOR="/usr/bin/vim --servername vim"

export WCDSCAN=$HOME
export TZ=Europe/London

if [ -e /opt/slickedit/bin ]; then
	export PATH=/opt/slickedit/bin:$PATH
fi

if [ -e /opt/firefox/firefox ]; then
	# manually downloaded and installed firefox update
	export PATH=/opt/firefox:$PATH
fi

if [ ! -z $COMPANY ]; then
	PATH=$HOME/bin/$COMPANY:$PATH
fi

if command -V __git_ps1 > /dev/null 2> /dev/null; then
# BSAC show git branch on command prompt
# see /etc/bash_completion.d/git for options
# Prompt branch looks like: (master *+$%<>)
# DIRTY STATE *=unstaged files +=staged changes
# STASH $=stashed files
# UNTRACKED %=untracked files
# UPSTREAM <=behind >=ahead <>=diverged from upstream
#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto verbose"

#BSAC duplicated from up above and added GIT branch info to prompt
if [ "$color_prompt" = yes ]; then
    # BSAC show git branch on command prompt
    PS1_SHORT='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\W\[\033[00m$(__git_ps1 " (%s)")\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m$(__git_ps1 " (%s)")\]\$ '
else
    # BSAC show git branch on command prompt
    PS1_SHORT='${debian_chroot:+($debian_chroot)}\W\[$(__git_ps1 " (%s)")\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\[$(__git_ps1 " (%s)")\]\$ '
fi
fi # __git_ps1

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1_SHORT="\[\e]0;${debian_chroot:+($debian_chroot)}\W\a\]$PS1_SHORT"
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# BSAC svn configuration for merging with diffmerge
export SVN_MERGE=$HOME/bin/svndiffmergeconflict.sh

# BSAC java setup for maven 3 builds
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export M2_HOME=/usr/share/maven

# BSAC raspberrypi setup
if [ $HOSTNAME == raspberrypi ]; then
    export JAVA_HOME=/usr/lib/jvm/jdk-8-oracle-arm-vfp-hflt
fi

# BSAC wipro setup
if [ "x$COMPANY" == "xwipro" ]; then
    # /Library/Java/JavaVirtualMachines/jdk1.8.0_151.jdk/Contents/Home
    # /Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home
    export JAVA_HOME=`/usr/libexec/java_home -v21`
    export M2_HOME=
    export GROOVY_HOME=/usr/local/opt/groovy/libexec
    export EDITOR="/usr/bin/vim"
fi

#BSAC match cygwin put functions in separate sourced file
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

#BSAC Node version manager allows you to have multiple versions of nodejs
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    [[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion
    # nvm ls
    # nvm ls-remote
    NODE_USE_VER=v8.6.0
    if [ -e "$HOME/.nvmrc" ]; then
        NODE_USE_VER=`cat "$HOME/.nvmrc"`
    fi
    nvm use "$NODE_USE_VER"> /dev/null || (echo "You need to manually: nvm install $NVM_USE_VER")
fi

if [ -z "$NODEJS_ORG_MIRROR" ]; then
    export NODEJS_ORG_MIRROR="$NVM_NODEJS_ORG_MIRROR"
fi

export CHROME_BIN=`which chromium-browser`
export NODE=`which node`

export PATH="/usr/local/sbin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
which pyenv > /dev/null && export PATH="`pyenv root`/shims:$PATH"

export PATH=`upath.sh`

export COLUMNS
export LINES


#export LC_ALL=en_UK.UTF-8
#export LANG=en_UK.UTF-8
#export LANGUAGE=en_UK.UTF-8

# on a Mac international keyboard, cannot easily type tilde and caret
if which sw_vers > /dev/null 2>&1; then
    # MACOS
    export t=~
    export c=^
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if [ "x$COMPANY" == "xwipro" ]; then
    # Added by cpan when ran it locally
    PATH="/Users/bcowgill/perl5/bin${PATH:+:${PATH}}"
    export PATH;
    PERL5LIB="/Users/bcowgill/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL5LIB
    PERL_LOCAL_LIB_ROOT="/Users/bcowgill/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_LOCAL_LIB_ROOT
    PERL_MB_OPT="--install_base \"/Users/bcowgill/perl5\""
    export PERL_MB_OPT
    PERL_MM_OPT="INSTALL_BASE=/Users/bcowgill/perl5"
    export PERL_MM_OPT
fi
