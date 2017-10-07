#!/bin/bash
# grep for disabled/only test markers in all repositories
# as defined by PJ and REPOS environment variables

if [ -z "$PJ" ]; then
	echo NOT OK you must define the PJ environment variable to indicate where your git projects are.
	exit 1
else
	if [ -z "$REPOS" ]; then
		echo NOT OK you must define the REPOS environment variable to indicate which git repository directories to process
		exit 2
	fi
	pushd $PJ
fi

# enable to see how command line modified
if false; then
	set -x
	true git grep $*
	set +x
fi

for dir in $REPOS
do
	echo " "
	echo $dir ======================================================
	pushd $dir > /dev/null
		git grep -E '(describe|it).(skip|only)' | grep -v 'test-runner-template.js' | grep -v 'test-main.js'

	perl -ne '
		if (m{notTestPlans \s* = \s*}xms) {
			$inNotList = 2;
			$inOnlyList = 0;
			$prefix = "karma notTestPlans";
		}
		if (m{onlyTestPlans \s* = \s*}xms) {
			$inNotList = 0;
			$inOnlyList = 2;
			$prefix = "karma onlyTestPlans";
		}
		if (m{\A \s* \](,|;)}xms) {
			$inNotList = $inOnlyList = $prefix = "";
				};
		if ($inOnlyList|$inNotList) {
			print "$prefix: $_" if ($inOnlyList+$inNotList == 1) && $_ !~ m{\A \s* /(/|\*)}xms;
			$inOnlyList -= 1 if $inOnlyList > 1;
			$inNotList -= 1 if $inNotList > 1;
		}
	' test/karma/test-main.js

	popd > /dev/null
done
