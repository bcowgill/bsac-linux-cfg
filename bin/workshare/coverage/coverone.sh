#!/bin/bash
# run one test plan with coverage and report only the associated module.
# assumes test plan named     ..../tests/MMMMM.spec.js  (or node/test)
# has associated modile named ..../MMMMM.js

# rm coverage.csv coverage.tar; ./scripts/coverone.sh app/utils/tests/MarkObject.spec.js ; ./scripts/coverone.sh app/utils/tests/Props.spec.js; cat coverage.csv ; tar tvf coverage.tar

SRC='app'
COV_DIR=coverage
COV_TAR=coverage.tar
COV_CSV=coverage.csv
COV_LOG=coverage.log
COV_INDEX=$COV_DIR/index.html
PKG=package.json5

TEST_PLAN=$1
if [ -z $TEST_PLAN ]; then
	echo usage: $0 [--all] [--list] path/to/a/single/test.spec.js

	echo "
Run coverage for a single test plan or for all of them, combining results
into a CSV and index.html

--list list all the test plans found.
--all  run all test plans one after the other combining results.
"
	exit 0
fi

PLANS=`find $SRC -name '*.spec.js' -o -name '*.node.js' -o -name '*.test.js' | sort -d`

#===========================================================================
# list all test plans
if [ $TEST_PLAN == "--list" ]; then
	echo $PLANS | perl -pne '$_ = join("", map { "$_\n" } split(/\s+/))'
	exit 0
fi

#===========================================================================
# cover all test plans
if [ $TEST_PLAN == "--all" ]; then
	rm $COV_CSV $COV_TAR $COV_LOG
	for test in $PLANS; do
		echo $test;
		./scripts/coverone.sh $test \
			| egrep -A 6 -i 'Covering Single|Coverage summary' \
			| egrep -v '^(--|>)' >> $COV_LOG; done

	tar xvf $COV_TAR
	# generate a new index page from the CSV results (skip Unknown%)
	./scripts/coverone-output.pl $COV_CSV > $COV_INDEX
	tar rf $COV_TAR $COV_INDEX $COV_CSV
	exit 0
fi

#===========================================================================
# cover one specific test plan
MODULE=`echo $TEST_PLAN | perl -pne 's{/tests/}{/}xmsg; s{\.(spec|node|test)}{}xmsg'`
COV_HTML=`basename $MODULE`.html

echo TEST_PLAN=$TEST_PLAN
echo MODULE=$MODULE
echo COV_HTML=$COV_HTML

# update the include nyc list in package.json5 with the single module
MODULE="$MODULE" perl -i.covbak -e '
	local $/ = undef;
	$_ = <>;
	s{
		("include" \s* : \s* \[ \s* /\*nyc-marker\*/ \s* ) [^\]]+ (\])
	}{$1 "$ENV{MODULE}" $2}xmsg;
	print
' $PKG

npm run json5
npm run clean:coverage
npm run clean:build:test
echo Covering Single Module $MODULE from $TEST_PLAN
npm run test:coverage:single -- $TEST_PLAN
# restore package.json5 to normal
mv $PKG.covbak $PKG
npm run json5

if [ ! -f $COV_CSV ]; then
	echo "Worst,File,Full Path,Statements,Statements Detail,Branches,Branches Detail,Functions,Functions Detail,Lines,Lines Detail,Test Plan" > $COV_CSV
fi
# first 12 span elements contain the total coverage resuls
# td.file.medium data-value contains file name
TMP=`mktemp`
(\
	cat $COV_CSV; \
	egrep 'span|data-value' $COV_INDEX \
	| MODULE="$MODULE" TEST_PLAN="$TEST_PLAN" perl -ne '
		unless ($filename) {
			if (m{data-value="([^"]+)"}xms)
			{
				$filename = $1
			}
		}
		if (m{<span[^>]*>\s*(.+?)\%?\s*</span>})
		{
			push(@spans, $1);
			if (scalar(@spans) >= 3)
			{
				$cov{$spans[1]} = "$spans[0]%,$spans[2]";
				if (!$worst || $spans[0] < $worst)
				{
					$worst = $spans[0]
				};
				@spans = ()
			}
		}
		END {
			print qq{$worst,$filename,$ENV{MODULE},$cov{Statements},$cov{Branches},$cov{Functions},$cov{Lines},$ENV{TEST_PLAN}\n}
		}
	' \
) | sort -n > $TMP
mv $TMP $COV_CSV

M=r
if [ ! -f $COV_TAR ]; then
	M=c
fi
tar ${M}f $COV_TAR $COV_DIR/$COV_HTML || find $COV_DIR -ls
