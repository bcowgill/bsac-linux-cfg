# .git_aliases (aka git-aliases.sh)
# How to use these aliases:
# http://mjk.space/git-aliases-i-cant-live-without/

# Source:
# https://github.com/mjkonarski/oh-my-git-aliases/raw/master/oh-my-git-aliases.sh

# Place the below into your .bashrc or appropriate shell config file
# if [ -f ~/.git-aliases ]; then
#     . ~/.git-aliases
# fi

# requires aliases: vdiff
# requires git-fetch-pull-request.sh
# requires git-new-branch.sh
# requires datestamp.sh
# requires git-rebase.sh

if git config --global --list | grep alias.h > /dev/null; then
	echo git aliases are already configured. > /dev/null
else
	# else we configure them now.
	# https://mijingo.com/blog/how-to-create-git-aliases
	A='git config --global alias.'

	${A}st  status
	${A}fe  fetch
	${A}co  checkout
	${A}p   push
	${A}c   commit
	${A}pl  pull
	${A}m   merge
	${A}mt  mergetool
	${A}a   add
	${A}b   branch
	${A}gr  grep
	${A}rb  rebase
	${A}rs  restore
	${A}t   tag
	${A}re  reset
	${A}d   diff
	${A}dt  difftool
	${A}cp  cherry-pick
	${A}sta stash
	${A}cl  clone
	${A}r   remote
	${A}l   log
	${A}gra graph
	${A}con config
	${A}h   help
	${A}zip 'archive --format=zip -o latest.zip HEAD'
	${A}graph 'log --oneline --graph --decorate --all'
fi

# some aliases for git to shorten commands
# http://mjk.space/git-aliases-i-cant-live-without/
# https://github.com/mjkonarski/oh-my-git-aliases/blob/master/oh-my-git-aliases.sh#L71
alias g='git'

alias gst='g status'
alias gss='gst; echo == $? =='
alias gsm="gst | perl -ne '\$done = 1 if m{Untracked \\s+ files:}xms; print unless \$done;'"
alias gsum="gst | perl -ne '\$print = 0 if m{Untracked \\s+ files:}xms; \$print = 1 if m{Unmerged \\s+ paths:}xms; print if \$print;'"
alias gssls='gst --short'
alias gsmls='gst --short --untracked-files=no'
alias gud="echo \`git status | grep 'deleted: ' | perl -pne 's{\s*deleted:\s*}{}xms'\`"

alias gfe='g fetch'
alias gfea='gfe --all'
alias gfpr='git-fetch-pull-request.sh'
alias gnb='git-new-branch.sh'

alias gp='g push'
alias ggpush='gp origin $(git_current_branch)'
alias gpb=ggpush
# ggpushf warning - dangerous, be careful especially on master
alias ggpushf='gp --force-with-lease origin $(git_current_branch)'
alias ggpusht='g push origin --tags'

alias gc='g commit'  # clashes with gc command
alias gc!='gc --amend'
alias gca='gc -a'
alias gca!='gca --amend'
alias gcv='gc --no-verify'

alias gl='g pull'
alias glr='gl --rebase'
alias glff='gl --ff-only'
alias gpr='pause; glr'
alias gitpp='pause; glr && gpb && datestamp.sh'
alias rpb='rm pause-build.timestamp'
alias pause='touch pause-build.timestamp'

alias gm='g merge'
alias gma='gm --abort'
alias gmff='gm --ff-only'
alias gmnff='gm --no-ff'
alias gmt='g mergetool'

alias ga='g add'
alias gap='ga --patch'
alias gai='ga -i'

alias gb='g branch'
alias gcb='git_current_branch'
alias gba='gb -a'
alias gbl='gb --list'
alias gblr='gb --list --remote'
alias gblu='gfea; touch branches.now.lst; mv branches.now.lst branches.old.lst; gblr | sort > branches.now.lst; vdiff branches.old.lst branches.now.lst'

alias ggr='g grep'

alias grs='g restore'
alias grss='grs --staged'
alias grsw='grs --worktree'
alias grsws='grsw --staged'

alias grb='g rebase'
alias grbi='grb --interactive'
alias grba='grb --abort'
alias grbc='grb --continue'
alias grbs='grb --skip'

alias gt='g tag'

alias gre='g reset'
alias greh='gre --hard'
alias ggrh='greh @{u}'

alias gd='g diff'
alias gdls='gd --name-only'
alias gdc='gd --cached'
alias gdo='gdt origin/$(git_current_branch) $(git_current_branch)'
alias gdt='gitdiffns'
alias gitdiff='g difftool --no-prompt'
alias gitdiffns='gitdiff --ignore-all-space'

alias gcp='g cherry-pick'
alias gcpa='gcp --abort'
alias gcpc='gcp --continue'

alias gsta='g stash'
alias gsts='gsta show --text'
alias gstas='gsta save'
alias gstaa='gsta apply'
alias gstaa1='gstaa stash@{1}'
alias gstaa2='gstaa stash@{2}'
alias gstaa3='gstaa stash@{3}'
alias gstd='gsta drop'
alias gstp='gsta pop'
alias gdrop='gstas crap && gstd'

alias gcl='g clone'

alias gr='g remote'

alias glog='g log --oneline --graph --decorate --all'
alias ggraph='glog --simplify-by-decoration'
#alias ggraph='g graph --simplify-by-decoration'

# CUSTOM master/develop may change for you...
# also, gco -  will checkout the last branch you had
alias gco='g checkout'
alias gcd='gco develop'
alias gcm='gco master'
alias grom='git-rebase.sh origin/master'
alias grbiod='grbi origin/develop'
alias grbiom='grbi origin/master'
