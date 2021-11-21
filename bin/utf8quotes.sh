#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will display a document of practical examples of unicode quotation marks and open/close punctuation marks.

--list  Shows listing of unicode open/close and initial/final punctuation classes without practical examples.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also unicode-sample.sh, utf8-view.sh unicode-alpha.sh unicode-test.pl utf8-ellipsis.pl utf8ls-letter.sh utf8ls-number.sh utf8tr.pl utf8ls.pl grep-utf8.sh grep-hibit.pl and other *utf* and *unicode* tools.

Example:

Show how to use all double quotes and brackets with unicode characters.

	$cmd | grep DOUBLE
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

if [ "$1" == "--list" ]; then
	cat ~/bin/character-samples/samples/open-close-unicode-punctuation.txt
	exit 0
fi

cat ~/bin/character-samples/samples/open-close-quote-punctuation.txt
