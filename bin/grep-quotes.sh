#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [files..].

This will find lines with unicode quotes and other characters in them from standard input or files.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

It spaces out the found characters and uses color to highlight them.

See also utf8quotes.sh, utf8-view.sh

Example:

...
"
#It surrounds the found characters with >>> <<< to mark them.
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


# For reference use with echo -e to color some text
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0;0m' # No Color

grep -E '[‛ʼ‘‚‘’❛❜❟❟‟“”„“❝❞❠❠〝〞〝〟‹›«»]|\\"' \
	$* \
	| grep -vE '"\b(apos|endash|[lr][sd]q)\b"' \
	| perl -pne '
		my $preq = " \033[0;35m"; # "  >>>  ";
		my $preqq = " \033[0;31m"; # "  >>>  ";
		my $preb = " \033[0;33m"; # "  >>>  ";
		my $post = "\033[0;0m "; # no color "  <<<  ";
		s{([‛ʼ‘‚‘’❛❜❟❟])}{$preq$1$post}xmsg;
		s{([‟“”„“❝❞❠❠〝〞〝〟]|\\")}{$preqq$1$post}xmsg;
		s{([‹›«»])}{$preb$1$post}xmsg;
	'

	# arabic ٪  replaced from %
