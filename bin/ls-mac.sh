#!/bin/bash
# list all hidden files a Mac creates
# http://www.westwind.com/reference/OS-X/invisibles.html

WHERE="${1:-.}"
shift

pushd "$WHERE" > /dev/null && (\
	ls -a $* | egrep '(\$(Recycle.Bin)|\.(_.+|apdisk|DS_Store|Trash|Trash-.+|Trashes|Spotlight-V100|fseventsd|TemporaryItems))$'; \
	# .Trash .Trash-UID are ubuntu linux
	# $Recycle.Bin is windows
	popd > /dev/null \
)
