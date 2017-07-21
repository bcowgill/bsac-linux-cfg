#!/bin/bash
# list all hidden files a Mac creates
# http://www.westwind.com/reference/OS-X/invisibles.html

WHERE="${1:-.}"
shift

pushd "$WHERE" > /dev/null && (\
	ls -a $* | egrep '\.(_.+|apdisk|DS_Store|Trash|Trashes|Spotlight-V100)$'; \
	popd > /dev/null \
)
