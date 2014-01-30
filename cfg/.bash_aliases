# bash alias file
# Brent S.A. Cowgill

# Show the path split into one dir per line
alias path='echo $PATH | perl -pne '\''s{:}{\n}xmsg'\'''

# edit config files and re-source them
alias vib='$EDITOR ~/.bashrc; source ~/.bashrc'
alias vial='$EDITOR ~/.bash_aliases; source ~/.bashrc'
alias vifn='$EDITOR ~/.bash_functions; source ~/.bashrc'
alias vitodo='$EDITOR ~/s/ontology/notes/TODO-AT-WORK.txt'
alias prompter='source `which toggle-prompt.sh`'

# go up the dir tree quickly
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# default options for some commands
alias cdiff='colordiff'
alias now='( date --rfc-3339=seconds ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"'

# use source gear diffmerge or vimdiff as a visual diff program
alias svndiff='svn diff --diff-cmd svndiffmerge.sh'
alias gitdiff='git difftool --no-prompt'
if which sgdm.exe >> /dev/null; then
   alias vdiff='sgdm.exe'
else
   if which diffmerge >> /dev/null; then
      alias vdiff='diffmerge --nosplash'
   else
      alias vdiff='vimdiff'
   fi
fi

# use fdupes to do something like my delsame.pl
alias delsame='fdupes --recurse --noempty --size --delete'

# some package aliases
# pkgfind search for a package
# pkgls show all files installed by package
alias pkgfind='pkgfind.sh'
alias pkgless='pkgless.sh'
alias pkgfiles='pkgfiles.sh'
alias pkgls='dpkg -L'

# wcd default color graphic selector. 
# wcdls just list what dirs match. 
# wcds show the wcd dir stack
# wcdscan rescan configured directories in background
# wcdv view configuration
# wcdl for normal select list. 
# wcdo for stdio version select list
alias wcd='\wcd -z50 -g --compact-tree --center-tree --color'
alias wd='wcd'
alias wcda='\wcd -z50 -g --compact-tree --center-tree --color --ascii-tree'
alias wcds='\wcd -z50 ='
alias wcdl='\wcd -z50'
alias wcdo='\wcd -z50 -o'
alias wcdls='\wcd -z50 --to-stdout'
alias wcdscan='\wcd -z50 -s &'
alias wcdv='\wcd -z50 --verbose notadirectoryonthedisksoweshouldjustseeconfiginfoforwcd'

if [ `hostname` == bcowgill-dt  ]; then
   #echo modifying aliases for host bcowgill-dt
   # = --compact-tree not present. use -ga mode instead
   # -T = --ascii-tree
   # -gc = --center-tree
   # -K  = --color
   # -od = --to-stdout
   # wcd will be defined as a function in .bash_functions
   alias wd='wcd -z50 -ga -gc -K'
   alias wcda='wcd -z50 -ga -gc -K -T'
   alias wcds='wcd -z50 ='
   alias wcdl='wcd -z50'
   alias wcdo='wcd -z50 -o'
   alias wcdls='wcd -z50 -od'
   alias wcdscan='wcd -z50 -s &'
   alias wcdv='wcd -z50 --verbose notadirectoryonthedisksoweshouldjustseeconfiginfoforwcd'
fi

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

