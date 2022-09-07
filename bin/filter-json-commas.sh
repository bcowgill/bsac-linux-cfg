#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
INPLACE=[-i] $cmd [--help|--man|-?] [json-file ...]

This will filter a JSON file and fix missing/unnecessary end-of-line commas where needed.

INPLACE    Environment variable -i or -i.bak to specify to perl to do inplace editing of the files.
json-file  JSON file names to filter or fix in place.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

See also json-change.sh json-common.pl json-insert.sh json-minus.pl json-plus.pl json-reorder.pl json-shave.pl json-syntax.pl

Example:
	$cmd this.json

	fix the commas in this.json printing to standard output.

	INPLACE=-i.bak $cmd this.json

	fix the commas in this.json saving a backup in this.json.bak before making any changes.

	INPLACE=-i $cmd this.json

	fix the commas directly in this.json without saving a backup.
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

perl $INPLACE -pne '
	#print STDERR "saved1: $saved\n";
	my $temp = $saved;
	#print STDERR "temp1: $temp\n";
	if (m[\A\s*\}]xms)
	{
		$temp =~ s{,\s*\z}{\n}xms;
		#print STDERR "end strip comma temp2: $temp\n";
		$temp .= $_;
		#print STDERR "temp3: $temp\n";
		$_ = undef;
		#print STDERR "end _: $_\n";
	} elsif (s{"\s*\z}{",\n}xms)
	{
		# nothing to do
		#print STDERR "add comma _: $_\n";
	}
	$saved = $_;
	#print STDERR "saved2: $saved\n";
	$_ = $temp;
	#print STDERR "out _: $_\n";
' $*
