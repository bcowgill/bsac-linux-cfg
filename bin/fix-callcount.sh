#!/bin/bash
# WINDEV tool useful on windows development machine
set -e

function usage
{
	echo "
usage: $(basename $0) file...

Fixes sinon spy based test plans which are missing spy.callCount checks.

Changes expect(spy.called).toBe...
     to expect(spy.callCount).toBe(0|1);

Changes expect(spy.calledOnce).toBe...
     to expect(spy.callCount).toBe(0|1);

Changes ).toEqual(
     to ).toBe(

Inserts expect(spy.callCount).toBe(1);

whenever it sees an expect(spy.lastCall...
                 or expect(spy.getCall(0)...
                 or expect(spy.firstCall...

Reasoning: When unit testing with spies, if you don't check the callCount but just go right to firstCall, lastCall or getCall you can get a confusing syntax error: [TypeError: Cannot read property 'args' of null].  But if you check the callCount you will be shown a number mismatch, which is easier to understand.  Also if the code changes and your spy gets called an additional time, the callCount test will fail and you can add the additional unit tests for the new call.

Changing toEqual to toBe is done because toBe is rarely the correct test to use as it is a deep comparison and is not needed on simple type tests.
"
}

if [ -z "$1" ]; then
	usage
fi

for file in $*
do
	echo $file
	in="$file.bak"
	out="$file"
	# because perl on windows doesn't do -i.bak too well
	cp "$out" "$in"

	perl -ne '
	my $op = q{\s*\(\s*};
	my $cp = q{\s*\)\s*};
	chomp();
	s{\).toEqual\(}{).toBe(}xms;
	if (s{expect$op(\w+)\.called(Once)?$cp\.to(.+)$}{expect($1.callCount).toBe(}xms)
	{
		my ($spy, $tail) = ($1, $3);
		$_ .= m{fals[ey]}xmsi ? qq{0)} : qq{1)};
	}
	if (/\A(\s*)expect(ObjectsDeepEqual)?\((\w+)\.(lastCall|firstCall|getCall\(0\))/xms)
	{
		my ($indent, $deep, $spy, $type) = ($1, $2, $3, $4);
		if ($lastLine =~ m{\A(\s*)expect$op(\w+)\.(callCount|called)}xms)
		{
			print qq{$_\n};
		}
		else
		{
			print qq{${indent}expect($spy.callCount).toBe(1);\n$_\n};
		}
	}
	else
	{
		print qq{$_\n};
	}
	$lastLine = $_;
	' "$in" > "$out"

done
