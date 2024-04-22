#!/bin/bash

# ./test-chain.sh go.sh
# ./test-chain.sh | grep -B1 'NOT OK'

# for f in filter-*; do vdiff filter-long/test-chain.sh $f/test-chain.sh; done
function usage {
echo "
$0 go.sh

Example of a ./go.sh command to use with this test chain:

vdiff out/success-suppress.out base/success-suppress.base; ./tests.sh ; ./tests.sh; git add base/

After running the tests the subdir the output file will be diffed so you can update it, then the tests are run again twice to ensure the out/ directory is removed then the base files will be updated.
"
}

if [ ! -z "$1" ]; then
	if [ ! -x "./$1" ]; then
		echo "ERROR: command './$1' is not executable, will not start the chain."
		usage
		exit 43
	fi
fi

pushd filter-long > /dev/null
./test-chain.sh $* | grep -E 'WARN|ERR|TEST|NOT OK'
popd > /dev/null
exit $?
