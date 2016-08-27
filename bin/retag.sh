#!/bin/bash
# retag files for emacs/vim

#DEBUG="--verbose --fields=+afikKlmnsSzt"
XREF=1
LANGOPTS="--langmap=JavaScript:.js.jsx.json"
# +fq adds a tag for the filename and qualified class members
TAGOPTS="--recurse --links=no --exclude=node_modules $LANGOPTS --extra=+fq"
ETAGOPTS="$TAGOPTS --etags-include=$HOME/bin/TAGS"

# show what kind of tags are supported by each language supported
if [ ! -z "$DEBUG" ]; then
	ctags --version
	ctags $LANGOPTS --list-languages
	ctags $LANGOPTS --list-kinds
	ctags $LANGOPTS --list-maps
	# find all known tags files
	locate --wholename --regex '\bTAGS$'
fi

if [ ! -z "$XREF" ]; then
	echo creating cross reference files
	ctags $TAGOPTS -x > ctags-cross-reference.txt
	ctags $TAGOPTS -x --c-kinds=f > ctags-function-reference.txt
	ctags $TAGOPTS -x --c-kinds=v --file-scope=no > ctags-global-reference.txt
fi

if [ -e TAGS ]; then
	echo retag for emacs
else
	echo intial tag for emacs
fi
ctags -e $DEBUG $ETAGOPTS

if [ -e tags ]; then
	echo retag for vim
else
	echo intial tag for vim
fi
ctags $DEBUG $TAGOPTS

if [ -e .gitignore ]; then
	echo check .gitignore
	egrep '^TAGS\b' .gitignore || perl -e 'print qq{# ignore editor tag files\nTAGS\n}' >> .gitignore
	egrep '^tags\b' .gitignore || echo tags >> .gitignore
fi
