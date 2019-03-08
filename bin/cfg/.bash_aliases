# bash alias file
# Brent S.A. Cowgill
# MOTE: there are custom aliases set by hostname

# Show the path split into one dir per line
alias path='echo $PATH | perl -pne '\''s{:}{\n}xmsg'\'''
# Unique path, remove duplicate dirs from path
alias upath='PATH=`echo $PATH | upath.sh`'

alias chksys='check-system.sh 2>&1 | tee ~/check.log | grep "NOT OK"'
alias dochks='rm ~/mynotify.log; check-system.sh 2>&1 | tee ~/check.log; less ~/mynotify.log ~/check.log'

alias sc=sound-control.sh

# edit config files and re-source them
alias se='source ./env.sh'
alias vib='$EDITOR ~/.bashrc; source ~/.bashrc'
alias vial='$EDITOR ~/.bash_aliases; source ~/.bashrc'
alias vifn='$EDITOR ~/.bash_functions; source ~/.bashrc'
alias vitodo='$EDITOR ~/s/ontology/notes/TODO-AT-WORK.txt'
alias vivim='$EDITOR ~/.vimrc'
alias vii3='$EDITOR ~/bin/cfg/.i3-config ~/bin/i3-launch.sh ~/bin/i3-start.sh'
alias prompter='source `which toggle-prompt.sh`'
alias promptshort='source `which toggle-prompt-short.sh`'

if [ -z $COMPANY ]; then
	alias vicron='crontab -e; crontab -l > $HOME/bin/cfg/crontab-home'
else
	alias vicron='crontab -e; crontab -l > $HOME/bin/cfg/$COMPANY/crontab-$HOSTNAME'
fi

alias em='NO_AT_BRIDGE=1 emacs'

alias ascii='pushd ~/bin/character-samples/samples; mc; popd'

#  like mkdir -p for files you want to touch
alias touch-p='touch_p'

# go up the dir tree quickly
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# see what is taking up disk space in home dir
alias duse='(pushd ~ > /dev/null; du-sk.sh | tee _usage.log; popd > /dev/null)'

if [ `hostname` == WYATT  ]; then
	# home machine drive letters
	alias clear='perl -e "print qq{\n} x 80"'
	export C=/cygdrive/c
	export D=/cygdrive/d
	export F=/cygdrive/f
	export K=/cygdrive/k
	alias c:='pushd $C'
	alias d:='pushd $D'
	alias f:='pushd $F'
	alias k:='pushd $K'

	alias subl='"$C/Program Files/Sublime Text 2/sublime_text.exe"'
fi

if [ "x$COMPANY" == "xclearbooks" ]; then
	alias cdauth='pushd ~/projects/clearbooks-micro-api-auth'
	alias cdacct='pushd ~/projects/clearbooks-micro-api-accounting'
	alias grst='git-rebase.sh origin/staging'
fi

if [ "x$COMPANY" == "xwipro" ]; then
	alias sl='./scripts/lint.sh'
	alias slf='./scripts/lint-fix.sh'
	alias nrdl='npm run dev:lloyds:commercial'
	alias nrdb='npm run dev:bos:commercial'
	alias yts='yarn test:summary'
	alias ytw='yarn test:watch'
	alias cdie8='pushd ~/workspace/projects/pas-card-controls-cwa-mca-ie8'
	alias cdfe='pushd ~/workspace/projects/pas-card-controls-cwa'
	alias cdkx='pushd ~/workspace/projects/know-tx'

	alias ls-cfapps='cf apps | grep card-cont | perl -pne "s{\s.+}{\n}xms" | sort'
	alias ls-cfroutes='(for a in j2-pas-card-control-api-master j2-pas-card-control-mock-master; do cf app $a; done) | perl -pne "s{(routes:)\s+}{\$1\\n }xmsg; s{,}{,\\n}xmsg"'
	alias ls-cfappdyn='(for a in j2-pas-card-control-api-ft-PAS-15693 j2-pas-card-control-mock-ft-PAS-15693; do cf app $a; done) | perl -pne "s{(routes:)\s+}{\$1\\n }xmsg; s{,}{,\\n}xmsg"'
	alias ls-mca='ls-cfroutes | grep "mca-j2" | perl -pne "s{\\A.+-cwa-(.+?)\\..+\\z}{\$1\\n}xmsg;" | sort | uniq'
fi

# default options for some commands
alias cdiff='colordiff'
alias now='( datestamp.sh ; date +%a ) | perl -pne "s{\n}{ }xms; END { print qq{\n}}"'
alias egrep='\egrep --exclude-dir=.git'
alias xterm='\xterm -fa "ProFontWindows" -fs 11'

alias screenls='ls /var/run/screen/S-$USER'
alias pstree='\pstree -a -h -p -u'

# use source gear diffmerge, perforce p4merge or vimdiff as a visual diff program
alias svndiff='svn diff --diff-cmd svndiffmerge.sh'
if which sgdm.exe >> /dev/null; then
	alias vdiff='sgdm.exe'
else
	if which diffmerge >> /dev/null; then
		alias vdiff='diffmerge --nosplash'
	else
		if which diffmerge.sh >> /dev/null; then
			alias vdiff='diffmerge.sh --nosplash'
		else
			if which meld >> /dev/null; then
				alias vdiff='meld'
			else
				alias vdiff='vimdiff'
			fi
		fi
	fi
fi

if which p4merge >> /dev/null 2>&1 ; then
	# p4merge is a good visual diff tool for image files but not so good for text.
	alias imgdiff='p4merge'
	#alias vdiff='p4merge -fg yellow -bg black' does not work
fi

# i3 window manager diff configuration
alias i3diff='pushd ~/bin; git difftool --no-prompt  172c656043e8902d8ff7bf14af61145002445cb8 cfg/.i3-config ; popd'

# use fdupes to do something like my delsame.pl
alias delsame='fdupes --recurse --noempty --size --delete'

# make sense of ps -ef
alias pswhat='pswide.sh | egrep "^\s*($USER|`id -u`)" | what-is-running.pl'

# info about ports
alias ls-ports='lsof -Pnl +M -i4'
alias ls-ports2='netstat -tulpn'

# some package aliases
# pkgfind search for a package
# pkgls show all files installed by package
alias pkgfind='pkgfind.sh'
alias pkgless='pkgless.sh'
alias pkgfiles='pkgfiles.sh'
alias pkgls='dpkg -L'

if [ $OSTYPE == darwin16 ]; then
	alias brew='HOMEBREW_NO_AUTO_UPDATE=1 brew'
fi

# some virtualbox aliases
alias ls-vbox='ls -al ~/VirtualBox\ VMs/ ~/.ievms/ ~/.config/VirtualBox/'

# some node/npm aliases
alias ls-nm="locate node_modules | perl -pne 's{(/node_modules).+}{\$1\n}xmsg' | uniq"
alias npm5="npm-json5"
#alias n-ls="ls /usr/local/n/versions/node"
alias n-ls="(n io list; n list) | perl -ne 'print if m{\A\s*\d}xms'"
alias n-vers="echo node latest: \`n --latest\`; echo node stable: \`n --stable\`; echo node lts: \`n --lts\`"
alias nvu="nvm use \`cat .nvmrc\`"
# some bower aliases
alias bower-links=bower-links.sh
alias bower-all-links='bower-links.sh ~'
alias ls-bower-links=bower-links
alias ls-bower-all-links=bower-all-links
alias ls-bower='find . -name bower_components; echo $HOME/.config/configstore; ls $HOME/.config/configstore'
alias bower-ls=ls-bower
alias bower-unlink='bower uninstall'

# some prettier aliases
alias pty="prettier --no-semi --use-tabs --tab-width 3 --single-quote --trailing-comma es5 --arrow-parens always"
alias _pty="pty '**/*.{js,jsx,ts,tsx,json,json5,css,less,scss,htm,html,md}'"
alias ptyls='_pty --list-different'
alias ptyp='pty --stdin' # --parser type
alias ptyfx='_pty --write'
alias ptycf='prettier --find-config-path' # filename
alias ptyfi='prettier --file-info' # filename

# some eslint aliases
alias esl="eslint '**/*.{js,jsx,ts,tsx}'"
alias eslcf='eslint --print-config'
alias eslp='eslint --stdin' # --stdin-filename filename --parser type

#f some stylelint aliases
alias stl="stylelint '**/*.{htm,html,css,less,sass,scss,ss}'"
alias stlcf="stylelint --print-config"
alias stlfx="stl --fix"
alias stlp="stylelint --stdin" # --stdin-filename filename --syntax type
alias stlvb="stl --formatter verbose"
alias stlrd="stl --report-needless-disables"
alias stlid="stl --ignore-disables"

# image tagging aliases
# add -json for json output
# add -r recursive
alias ls-exif='exiftool -T -imagesize -bitdepth -filetype -datetimecreated -filesize -subject -tagslist -keywords -description -filename'
# extract exif info to .txt file in same dir as picture
alias get-exif='exiftool -w .txt'

# unicode aliases
alias ls-utf8=utf8ls.pl
alias utf8-sample=unicode-sample.sh

# use midnight commander to select a directory to pushd
alias pushmc='. $HOME/bin/mc-wrapper.sh'

if which sw_vers > /dev/null 2>&1; then
	# no wcd available on Mac
	true
else
	# wcdscan rescan configured directories in background
	# wd default color graphic tree selector.
	# wcda ascii based tree selector.
	# wcdl paged select list.
	# wcdo for stdio select list.
	# wcdls just list what dirs match.
	# wcdfind use regex match against list of directories.
	# wcds show the wcd dir stack and allow select
	# wd - or + go back or forward in wcd stack
	# wcdv view configuration
	# -z 50 wcd dir stack size
	# -w always a wild match, not exact match
	alias wcd='\wcd -w -z 50 -g --compact-tree --center-tree --color'
	alias wd='wcd -w -z 50 -g --compact-tree --center-tree --color'
	alias wcda='wd -w --ascii-tree'
	alias wcds='wd ='
	alias wcdl='wcd -w -z 50'
	alias wcdo='wcd -w -z 50 -o'
	alias wcdls='wd -w --to-stdout'
	alias wcdfind='cat ~/.wcd/.treedata.wcd | egrep'
	alias wcdscan='wd -s &'
	alias wcdv='wcd -z 50 --verbose notadirectoryonthedisksoweshouldjustseeconfiginfoforwcd'
fi

alias charles-up='source `which proxy-to-charles.sh`'
alias charles-down='source `which proxy-off.sh`'

# To simulate an ajax request to a back end
# ajax -iX GET http://url  to show headers and payload
# ajax -X GET http://url   to just get payload
alias ajax="curl -H 'X-Requested-With: XMLHttpRequest'"

alias utf8cut1='perl -CIO -pne "\$_ = substr(\$_, 0, 1)"'
alias utf8cut1nl='perl -CIO -pne "\$_ = substr(\$_, 0, 1) . qq{\n}"'

# First perltidy run on a file preserve any existing closing side comments
# perltidy -b file.pl    to tidy file in place
# perltidy -g file.pl    shows nesting of braces, brackets, etc
# perltidy -st file.pl   tidies to standard output
alias perltidy-firsttime='perltidy --closing-side-comment-warning'
alias perltidy-mine='rm ~/.perltidyrc; ln -s ~/bin/cfg/.perltidyrc ~/.perltidyrc'
alias perltidy-work='rm ~/.perltidyrc; ln -s ~/bin/cfg/.perltidyrc-blismedia ~/.perltidyrc'

# Testing aliases
alias debug-karma='karma-debug.sh'

# General Database aliases
alias myhist='cat ~/.mysql_history'
alias myhistory='cat ~/.mysql_history'

# Template Toolkit helpful alias find all markup
alias findtt='(HOLD_ECHO=$LS_TT_TAGS_ECHO; export LS_TT_TAGS_ECHO=1; find . -name *.tt -exec ls-tt-tags.pl {} \; ; export LS_TT_TAGS_ECHO=$HOLD_ECHO)'
alias alltt='(HOLD_ECHO=$LS_TT_TAGS_ECHO; HOLD_INLINE=$LS_TT_TAGS_INLINE; export LS_TT_TAGS_ECHO=0; export LS_TT_TAGS_INLINE=1; find . -name *.tt -exec ls-tt-tags.pl {} \; | sort | uniq ; export LS_TT_TAGS_ECHO=$HOLD_ECHO; export LS_TT_TAGS_INLINE=$HOLD_INLINE)'

if [ `hostname` == WYATT  ]; then
	# home machine cygwin clear screen command missing
	alias clear='perl -e "print qq{\n} x 80"'
fi
alias cls=clear

if [ `hostname` == worksharexps-XPS-15-9530 ]; then
	alias viscratch='vim $HOME/workspace/000_scratch.txt'
	alias vinotes='vim $HOME/workspace/notes.txt'
	alias gr='grunt --gruntfile Gruntfile.linux.js'
	alias grsq='git-rebase.sh origin/sysqa'
	alias gpfdi='git push -f origin debug-inheritance'
	alias gpf20='git push -f origin case#33230-code-coverage'
	alias gcdi='git checkout debug-inheritance'
	alias gcstory='git checkout case#29521-grid-view-comments'
	alias gc20='git checkout case#33230-code-coverage'
fi

if [ `hostname` == slug ]; then
	#echo modifying aliases for host at blismedia
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

	alias gitdiffns='git difftool --no-prompt --ignore-all-space --ignore-blank-lines'

	# Blismedia database aliases
	# add for output to CSV format: -F ',' --no-align
	alias dbinf='mysql -u root -p -D infinity_dashboard'
	alias dbp42davide='psql -h pg-project42 geodata postgres'
	alias dbp42='psql -h postgis-project42.cw0nipflfk4w.us-east-1.rds.amazonaws.com project42 awsuser -F "," --no-align'

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
alias lss='ls -al -oSr'   # list by size reversed

# if calc is missing, simulate it with perl
if which calc >> /dev/null; then
	true
else
	alias calc=calc.sh
fi
