# bash alias file
# Brent S.A. Cowgill

# go up the dir tree quickly
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# some aliases for git
alias gfa='git fetch --all'
alias gbl='git branch --list'
alias gblr='git branch --list --remote'
alias gpr='git pull --rebase'
alias gca='git commit --amend'
alias gcp='git cherry-pick'
alias gma='git merge --abort'
alias gmt='git mergetool'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grs='git rebase --skip'
alias glog='git log --oneline --graph --decorate --all'
alias ggraph='glog --simplify-by-decoration'
#alias ggraph='git graph --simplify-by-decoration'

############################################################################
# Some example alias instructions (from cygwin default .bashrc)
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#
# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'
#
# Default to human readable figures
# alias df='df -h'
# alias du='du -h'
#
# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
# alias grep='grep --color'                     # show differences in colour
# alias egrep='egrep --color=auto'              # show differences in colour
# alias fgrep='fgrep --color=auto'              # show differences in colour
#
# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
# alias ll='ls -l'                              # long list
# alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #
alias lss='ls -al -oSr'   # list by size reversed
