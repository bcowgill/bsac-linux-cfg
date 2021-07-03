#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [filename.csv]

This will take a CSV UTF-8 comma delimited values file (Saved from Excel) and display a JSON language file.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Assumes this format:

message-id , other lanugage text

See also json2csv.sh json-plus.pl json-minus.pl json-insert.sh json-common.pl json_pp json_xs jq

Examples

Delete English column from all sheets in Excel workbook.
Save each tab As CSV UTF-8 comma delimited values files.
run dos2unix on each file.

$cmd malaysian.csv > my.json

cat ar1.csv ar2.csv | $cmd > ar.json

You will probably have to fix various things up.

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

perl -CI -CO -CE -Mstrict -Mwarnings -ne '
	next if m{\A\s*\z}xms;

	chomp;
  my $q = chr(39);
  warn "$. Unrecognised line: $_\n" unless m{\A\s*"?\s*(.+?)\s*"?\s*,\s*"?\s*(.+?)\s*"?\s*\z};
	my ($id, $language) = ($1, $2);
  # handle the unicode marker character that Excel spits out first
  next if $id =~ m{\A.{0,3}Key}xms;
  warn "line $. Double quote found in id change to “”: $id\n" if $id =~ m{"}xms;
  warn "line $. Single quote found in id change to ‘’: $id\n" if $id =~ m{$q}xms;
  warn "line $. Double quote found in message change to “”: $language\n" if $language =~ m{"}xms;
  warn "line $. Single quote found in message change to ‘’: $language\n" if $language =~ m{$q}xms;
	print qq{  "$id": "$language",\n};

	BEGIN { print "{\n" }
	END { print "}\n" }
' $*

exit 0
