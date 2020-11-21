#!/bin/bash
# want something like:

# docs === .doc .docx  images === .jpg .gif, etc
#find . -type f | perl -pne 'chomp; $_ =~ m{\A (.*? /) ([^/]+) \z}xms or die qq{no match for path/filename: [$_]\n}; my ($path, $filename) = ($1, $2); $_ = "$path $filename\n"'

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--help|--man|-?] directory

Work in progress.

This will examine all the files in the directory given and below and classify them into different file types then display a summary of what is present there.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It will ignore everything within any node_modules or .git directories encountered.

Displays output something like:

57: ./documents 44 docs; 13 images;
32: ./path/ 12 documents, 20 images

See also whatsin.sh, ls-types.pl

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

DIR=${1:-.}
find $DIR -type f | grep -vE '/(\.git|node_modules.*)/' | ls-types.pl | sort -g -r

exit 0
