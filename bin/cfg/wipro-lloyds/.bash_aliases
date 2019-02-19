alias vib='$EDITOR ~/.bashrc; source ~/.bashrc'
alias vial='$EDITOR ~/.bash_aliases; source ~/.bashrc'
alias vifn='$EDITOR ~/.bash_functions; source ~/.bashrc'
alias vivim='$EDITOR ~/.vimrc'

# go up the dir tree quickly
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# some aliases for git rebasing
alias gss='git status; echo == $? =='
alias gsm="git status | perl -ne '\$done = 1 if m{Untracked \\s+ files:}xms; print unless \$done;'"
alias gblu='git fetch --all; touch branches.now.lst; mv branches.now.lst branches.old.lst; git branch --list --remote | sort > branches.now.lst; vdiff branches.old.lst branches.now.lst'

alias lss='ls -al -oSr'   # list by size reversed

alias vihosts='vim /c/Windows/System32/Drivers/etc/hosts'

alias vdiff='kdiff3.exe'

alias nrba="npm run build:all"
alias nrs="npm run storybook"
alias nrtw="npm run test:watch"
alias nrtu="npm run test:unit"
alias nro="TEST_DEBUG=1 npm run test:unit -- --testRegex"
alias nrt="npm run test"
