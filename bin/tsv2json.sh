#!/bin/bash

if [ -z "$1" ]; then
	cmd=`basename $0`
	echo "
$cmd filename.tsv

This will take a tab separated values file (exported from Excel) and display a JSON language file.

Assumes this format:

message-id [tab] english text [tab] other lanugage text


Examples

$cmd malaysian.tsv > my.json
"
	exit 0
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
