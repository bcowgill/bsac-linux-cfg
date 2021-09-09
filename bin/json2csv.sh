#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [filename.json]

This will take a JSON language file and display it as a CSV UTF-8 comma delimited values file (For import to Excel).

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Assumes this format:

 \"message-id\": \"other lanugage text\",

Any excess spaces next to the double quotes in the other language text will be stripped and should be encoded as %sp% if necessary.

There must not be any regular 'single' or \"double\" quote marks in the other language text.

They should be converted to unicode ‘single’ and “double” quotes.

If there are an even number of such quotes in a string they will automatically be converted.

See also csv2json.sh json-plus.pl json-minus.pl json-insert.sh json-common.pl json_pp json_xs jq

Examples

$cmd en.json > english-to-arabic.csv
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

ERR=`mktemp`

echo "Key,English Source,Target Language,Notes"
# -CI -CO -CE
perl -ne '
	next if m{\A\s*\z}xms;
	next if m[\A\s*{\s*\z]xms;
	next if m[\A\s*}\s*\z]xms;

	chomp;
	my $SQOK = 0;
	my $notes = "";
	my $translate = "";
	my $q = chr(39);
	my $qq = chr(34);
	my @qr = qw(‘ ’);
	my @qqr = qw(“ ”);
	my $orig = $_;
	s{$qr[0]}{\%lsq\%}xmsg;
	s{$qr[1]}{\%rsq\%}xmsg;
	s{$qqr[0]}{\%ldq\%}xmsg;
	s{$qqr[1]}{\%rdq\%}xmsg;
	warning("Unrecognised line: $_") unless m{\A\s*"\s*(.+?)\s*"\s*:\s*"\s*(.*?)\s*",?\s*\z};
	# warning("QUOTES: $_") if $_ ne $orig;
	my ($id, $language) = fix($1, $2);
	next if $id =~ m{CHANGENEEDED}xms;
	if ($id =~ m{\A([rl][sd]q|(w|nb)?sp|endash)\z}xms
		|| $id =~ m{
			_confluence|
			languagePicker\.label\.|
			(\w+)Email|
			global\.email(Subject|Context)|
			\.slide\d+\.image
		}xms
	)
	{
		my $DO = "DO";
		$translate = $language;
		$translate =~ s{/\d+/}{/TO$DO/}xms;
		$notes = "LEAVE AS IS";
		$notes = "SET TO LEFT or RIGHT SINGLE or DOUBLE quote character for the target language if different from English" if $id =~ m{[rl][sd]q}xms;
	}
	print qq{$id,"$language","$translate","$notes"\n};
	print qq{$id.NEWLANGUAGE,"EN","","Specify short name/ISO639-1 two character code for your language in your language character set See https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes"\n} if $id eq "languagePicker.label";

	sub warning {
		my ($message) = @_;
		warn "line $.: $message\n";
	}
	sub check {
		my ($changed, $type, $key, $name, $id, $qq, $to) = @_;
		if ($id =~ m{$qq}xms)
		{
			++$changed;
			my $found = count($qq, $id);
			if ($found % 2)
			{
				warning("$key: Odd number of $type quotes $qq found in $name, change to $to; cannot correct automatically: $id")
			}
			else
			{
				warning("$key: $type quote $qq found in $name, change to $to: $id");
			}
		}
		return $changed;
	}
	sub fix {
		my ($id, $language) = @_;
		my $changed = 0;
		$changed = check($changed, "Double", $id, "id", $id, $qq, join("", @qqr));
		$changed = check($changed, "Double", $id, "message", $language, $qq, join("", @qqr));
		unless ($SQOK) {
			$changed = check($changed, "Single", $id, "id", $id, $q, join("", @qr));
			$changed = check($changed, "Single", $id, "message", $language, $q, join("", @qr));
		}
		if ($changed) {
			$id = fix_quote($q, $id, $qr[0], $qr[1]);
			$id = fix_quote($qq, $id, $qqr[0], $qqr[1]);
			$language = fix_quote($q, $language, $qr[0], $qr[1]);
			$language = fix_quote($qq, $language, $qqr[0], $qqr[1]);
			print STDERR qq{POSSIBLE CORRECTION:  "$id": "$language",\n};
		}
		return ($id, $language);
	}
	sub count
	{
		my ($qq, $string) = @_;
		my $found = 0;
		$string =~ s{$qq}{++$found; $qq}xmsge;
		return $found;
	}
	sub fix_quote {
		my ($q, $string, $ql, $qr) = @_;
		my $found = count($q, $string);
		my $number = 0;
		$string =~ s{\\$q}{$q}xmsg;
		if ($found == 1)
		{
			$string =~ s{$q}{$qr}xms;
		}
		else
		{
			$string =~ s{$q}{$number++ % 2 ? $qr : $ql}xmsge;
		}
		return $string;
	}
' $* \
2> $ERR

if [ `cat $ERR | wc -l` != "0" ]; then
	perl -ne 'print STDERR' $ERR
	exit 1
fi
