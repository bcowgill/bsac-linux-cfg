#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# retag files for emacs/vim

# emacs tag quick ref
# Alt-x visit-tags-table <RET> TAGS <RET>
# Alt-. <RET>    # find tag at cursor
# Ctrl-u Alt-.   # find next matching tag
# Alt-- Alt-.    # back to previous matching tag
# Alt-*          # pop back to where you were

# vim tag quick ref
# vim -t tag  # start vim and position cursor at tag definition
# :ta tag   # find a tag by name
# Ctrl-]    # find tag at cursor
# Ctrl-t    # pop back to where you were

#DEBUG="--verbose --fields=+afikKlmnsSzt"
#XREF=1
LANGOPTS="--langmap=JavaScript:.js.jsx.json"
# +fq adds a tag for the filename and qualified class members
TAGOPTS="--recurse --links=no --exclude=.tmp --exclued=.git --exclude=node_modules --exclude=bower_components --exclude=dist --exclude=coverage $LANGOPTS --totals=yes"
ETAGOPTS="$TAGOPTS"
# --extra=+fq --etags-include=$HOME/bin/TAGS"

function say {
	local message
	message="$1"
	echo "$message"
	which mynotify.sh > /dev/null && mynotify.sh "retag.sh" "$message"
}

function retag_dir {
	local dir
	dir="$1"
	if [ -e TAGS ]; then
		echo "$dir"
		if [ `find . -newer TAGS -type f | wc -l` != 0 ]; then
			say "retagging $dir"
			retag.sh
		else
			echo "nothing newer than the TAGS file"
		fi
	fi
}

MODE=${1:-single}
if [ "$MODE" == "list" ]; then
	# find all tag files
	locate --wholename --regex '\bTAGS$' | grep $HOME | sort
	exit 0
fi
if [ "$MODE" == "all" ]; then
	# find all tag files and update tags if any newer files are present
	for tagfile in `locate --wholename --regex '\bTAGS$' | grep $HOME | sort -r`; do
		dir=`dirname "$tagfile"`
		pushd $dir > /dev/null && (retag_dir "$dir" ; popd > /dev/null)
	done
else

	# show what kind of tags are supported by each language supported
	if [ ! -z "$DEBUG" ]; then
		ctags --version
		ctags $LANGOPTS --list-languages
		ctags $LANGOPTS --list-kinds
		ctags $LANGOPTS --list-maps
	fi

	if [ ! -z "$XREF" ]; then
		echo creating cross reference files
		ctags $TAGOPTS -x > ctags-cross-reference.txt
		ctags $TAGOPTS -x --c-kinds=f > ctags-function-reference.txt
		ctags $TAGOPTS -x --c-kinds=v --file-scope=no > ctags-global-reference.txt
	fi

	if [ -e .gitignore ]; then
		echo check .gitignore
		egrep '^TAGS\b' .gitignore > /dev/null || perl -e 'print qq{# ignore editor tag files\nTAGS\n}' >> .gitignore
		egrep '^tags\b' .gitignore > /dev/null || echo tags >> .gitignore
	fi

	if [ -e tags ]; then
		echo retag for vim
	else
		echo intial tag for vim
	fi
	ctags $DEBUG $TAGOPTS

	if [ -e TAGS ]; then
		echo retag for emacs
	else
		echo intial tag for emacs
	fi
	ctags -e $DEBUG $ETAGOPTS

fi
