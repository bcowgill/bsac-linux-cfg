# git-aliases.sh

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
