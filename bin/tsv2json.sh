#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [filename.tsv]

This will take a tab separated values file (exported from Excel) and display a JSON language file.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Assumes this format:

message-id [tab] english text [tab] other lanugage text

See also json-plus.pl json-minus.pl json-common.pl json_pp json_xs jq

Examples

$cmd malaysian.tsv > my.json
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
	next if m{\A\s*\z}xms;

	chomp;
	my ($id, $english, $language) = split(/\t/);
	$id =~ s{\A\s*(.*?)\s*\z}{$1}xms;
	$language =~ s{\A\s*(.*?)\s*\z}{$1}xms;

	print qq{  "$id": "$language",\n};

	BEGIN { print "{\n" }
	END { print "}\n" }
' $*

exit 0
