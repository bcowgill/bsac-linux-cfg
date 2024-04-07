#!/bin/bash
# Produce list of uncovered tools...
git grep -E '(PROGRAM|SUITE)=' | grep '.sh:' | grep -vE '(program|TESTME|perl-(lite|script|inplace))\.pl|NODE\s\$PROGRAM' | perl -ne '
	my $raw = $_;
	chomp;
	if (m{SUITE=(.+)\z|perltidy}xms)
	{
		$suite = $1;
		next;
	}
	s{\$SUITE}{$suite}xms if $suite;;
	s{\A.+PRO GRAM=(.+/)?}{}xms;
	s{"\s*\z}{}xms;
	$_ .= "\n";
	print;
	print STDERR qq{$raw} if m[\}]xms;
' 2> raw.lst | sort > covered.lst

DIR=`pwd`
pushd .. > /dev/null
	ls -1 *.js *.pl *.sh | sort > $DIR/all-tools.lst
popd > /dev/null
diff all-tools.lst covered.lst > diffed.lst

grep -vE '\A\d+,\d+' diffed.lst | grep '<' | perl -pne 's{<}{}xms' > uncovered.lst

echo Possible Errors in logic:
grep -vE '\A\d+,\d+' diffed.lst | grep '>'

rm diffed.lst
COV=`wc -l < covered.lst`
UNCOV=`wc -l < uncovered.lst`
echo $COV Covered tools are listed in covered.lst
echo $UNCOV Uncovered tools are listed in uncovered.lst
echo `calc 100*$COV/$UNCOV` % covered
