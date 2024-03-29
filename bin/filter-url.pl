#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] [filename...]

This will display only https?:// URLs from standard input or files provided and display on standard error.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

This is intended to be used to extract links from HTML files but will also work for Markdown and other file types.

Example:

	Extract the URLs from a local HTML file.

	$(basename $0) index.html 2> urls.lst

	Fetch a web page save it to index.html and extract the URLs into another file.

	curl http://... | tee index.html | $(basename $0) 2> urls.lst

"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

perl -ne '
	my ($q, $Q) = (chr(39), chr(34));
#		(https?://\S+?)[$q$Q]?
	s{
		(https?://[^\s$q$Q`\)\]\}\>]+)
	}{
		print STDERR "$1\n"
	}xmsge;'
