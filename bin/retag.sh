#!/bin/bash
# retag files for emacs/vim

#DEBUG="--verbose --fields=+afikKlmnsSzt"
#XREF=1
LANGOPTS="--langmap=JavaScript:.js.jsx.json"
# +fq adds a tag for the filename and qualified class members
TAGOPTS="--recurse --links=no --exclude=node_modules $LANGOPTS --extra=+fq --totals=yes"
ETAGOPTS="$TAGOPTS"
# --etags-include=$HOME/bin/TAGS"

function say {
	local message
	message="$1"
	echo "$message"
	which notify > /dev/null && notify -t "retag.sh" -m "$message"
}

if [ "${1:-single}" == "all" ]; then
	# find all tag files and update tags if any newer files are present
	for tagfile in `locate --wholename --regex '\bTAGS$' | grep $HOME | sort -r`; do
		dir=`dirname "$tagfile"`
		pushd $dir > /dev/null
			echo $dir
			if [ `find . -newer TAGS -type f | wc -l` != 0 ]; then
				say "tagging $dir"
				retag.sh
			fi
		popd > /dev/null
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
