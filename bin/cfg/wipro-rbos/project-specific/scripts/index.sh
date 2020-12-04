#!/bin/bash
# Generate indexes of relevant file types
# set -x

# index.sh | tee file-stats.txt
# index.test.sh # creates dummy files for testing this script

# WINDEV useful tool on windows development systems
# CUSTOM settings to set manually on a new computer
SRC=src
GGREP="git grep"
#GGREP="grep -r"  # for testing the script

if [ ! -d $SRC ]; then
	echo "
$(basename $0) should be run from your project containing ./$SRC directory.

You are currently in:
"
	pwd
	exit 1
fi

pwd
git branch | grep '*'
rm src-*.lst

find $SRC -type f > src-files.log
find $SRC -name "*.jsx" > src-js-react.lst
find $SRC -name "*.test.js" -o -name "*.spec.js" > src-js-tests.lst
find $SRC -name "setupTests.js" > src-js-config.lst
find $SRC -name "*.snap" > src-js-test-snapshots.lst
find $SRC -name "*.css" > src-stylesheets.lst
find $SRC -name "*.png" > src-images.lst

# read first list of files until the gap text XYZZY x 2
# then remove each file from the list if it is seen again.
function find_remainders {
	local out
	out="$1"
	shift

	echo XYZZYXYZZY > gap.lst
	perl -MData::Dumper -ne '
		chomp;
		if (m{\AXYZZYXYZZY\z}xms)
		{
			$gap = 1;
		}
		if ($gap)
		{
			delete $File{$_};
		}
		else
		{
			$File{$_} = 1;
		}
		END
		{
			print join("\n", sort(keys(%File)));
			print "\n";
		}
	' $* > $out
}

# remove all classified files from the main scan of files giving leftovers
find_remainders remainder.lst src-files.log gap.lst src-*.lst

grep -E '\.js$' remainder.lst > src-js-files.lst
grep -vE '\.js$' remainder.lst > src-unknown.lst
mv src-files.log src-files.lst
rm remainder.lst

JS_CODE=`cat src-js-files.lst src-js-react.lst | wc -l`
JS_TESTS=`cat src-js-tests.lst | wc -l`

echo `cat src-files.lst | wc -l` Files in $SRC/
echo $JS_CODE Total JS Code Files
echo `cat src-js-react.lst | wc -l` JS React Files
echo `cat src-js-files.lst | wc -l` JS Code Files
echo $JS_TESTS JS Test Plan Files
echo `cat src-js-test-snapshots.lst | wc -l` JS Test Snapshot Files
echo `cat src-js-config.lst | wc -l` JS Configuration Files
echo `cat src-stylesheets.lst | wc -l` Stylesheet Files
echo `cat src-images.lst | wc -l` Image Files
echo `cat src-unknown.lst | wc -l` Unknown Files \(see src-unknown.lst\)

# show numbers of test files vs js files and % tested
#echo JSC=$JS_CODE
#echo JST=$JS_TESTS
perl -e '
	my ($code, $test) = @ARGV;
	my $files = $code - $test;
	my $percent = $test / $code;
	$percent = int(10000 * $percent) / 100;
	print qq{JS Code is $percent % tested, needs $files more test plans\n};
' $JS_CODE $JS_TESTS

# check which files have test plans and which dont
SRC=$SRC perl -pne '
	my $DEBUG = 0;
	my $q = chr(39);
	my $TEST = "test"; # or spec
	my $JSTEST = ".$TEST.js";
	my $QMJSTEST = quotemeta($JSTEST);
	my $TOPTEST = "test"; # or spec
	my $DIRTEST = "__test__"; # or spec
	my $mv = "git mv ";
	my $bak = ""; #".bak";
	my $cmt = "git commit";

	# identify source file that a test plan tests when it is non-standard but acceptable
	my %testMap = qw(
		src/components/widgets/__test__/listbox2.test.js
			src/components/widgets/listbox.jsx
	);

	sub output
	{
		my ($s, $t, $nomove) = @_;
		$_ = qq{\necho OK $t tests $s\n};
		my $ideal = $s;
		$ideal =~ s{\.jsx?}{$JSTEST}xms;
		$ideal =~ s{(/[^/]+)\z}{/$DIRTEST$1}xms;
		$ideal =~ s{/$DIRTEST/$DIRTEST/}{/$DIRTEST/}xms;
		my $name = $ideal;
		$name =~ s{\A.+/([^/]+)$QMJSTEST.*\z}{$1}xms;
		print STDERR qq{test: $t ideal: $ideal\n} if $DEBUG;
		if (!$nomove && $t ne $ideal)
		{
			# output commands to git move test plan to better name
			# and fix the import line for the object under test
			my $make = qq{mkdir -p $ideal};
			my $remove = qq{rmdir $ideal};
			my $move = qq{git mv $t $ideal};
			my $add = qq{git add $ideal};

			my $perl = qq{perl -i$bak -pne ${q}\$Q = chr(39) . chr(34);};
			my $search = qq{s{(from.+)([\$Q]).+/$name\\2}{\$1\$2../$name\$2}xms};

			$_ .= qq{$make\n$remove\n$move\n};
			push(@Replace, qq{$perl $search $q $ideal\n$add\n\n});
		}
	}

	sub found
	{
		my ($s, $t, $nomove) = @_;
		my $result = 0;
		print STDERR qq{Look for Source: $s for Test: $t\n} if $DEBUG;
		if ($s ne $t && -f $s)
		{
			output($s, $t, $nomove);
			print STDERR qq{$s\n};
			$result = 1;
		}
		return $result;
	}

	chomp;
	my $src = $ENV{SRC};
	my $source = $_;
	my $test = $_;

	# assume source file name .js or .jsx from test plan and check if present
	#my $r = qr{\.$TEST(\.js)\z}xms;
	#print STDERR qq{regex: $r\n} if $DEBUG;
	$source =~ s{\.$TEST(\.js)\z}{$1}xmsg;
	if (found($source, $test)) { next; }
	$source .= "x";
	if (found($source, $test)) { next; }

	# assume a test subdir and look for source file name
	$source =~ s{$DIRTEST/}{}xms;
	if (found($source, $test)) { next; }
	$source =~ s{(js)x\z}{$1}xms;
	if (found($source, $test)) { next; }

	# assume a top level testing dir and look for source file name in scan lists
	$source =~ s{$src/$TOPTEST/}{}xms;
	$where = `grep $source src-js-react.lst src-js-files.lst`;
	chomp($where);
	if ($where =~ s{\A.+:}{}xms)
	{
		$source = $where;
		output($source, $test);
		next;
	}
	if ($testMap{$test})
	{
		if (found($testMap{$test}, $test, "nomove")) { next; }
	}
	$_ = qq{# NOT OK $test UNKNOWN source\n};

	sub BEGIN
	{
		print qq{#!/bin/bash\n};
	}

	sub END
	{
		if (scalar(@Replace))
		{
			print qq{\n$cmt -m "wip \$JIRA Renamed test plans as $DIRTEST/..."\n\n};
			print join("\n", @Replace);
			print qq{\n\n$cmt -m "wip \$JIRA Fixed imports for renamed test plans"\n};
		}
	}

' src-js-tests.lst > test-map.lst 2> src-js-has-testplan.lst

# Find which JS source files have no test plans associated.
find_remainders src-js-untested.lst src-js-files.lst src-js-react.lst gap.lst src-js-has-testplan.lst
rm gap.lst

echo `grep 'mv ' test-map.lst | wc -l` Test Plans to be renamed \(see test-map.lst\)
echo `grep UNKNOWN test-map.lst | wc -l` Tests with unknown source files
grep UNKNOWN test-map.lst
echo `cat src-js-untested.lst | wc -l` JS Files without Test Plans \(see src-js-untested.lst\)

# echo stopping early...
# exit 1

find node_modules -type f > node-modules.lst &

$GGREP eslint-disable $SRC > lint-overrides.lst
echo `cat lint-overrides.lst | wc -l ` Lint rule overrides \(see lint-overrides.lst\)
$GGREP -E '(window|document)\.' $SRC > globals.lst
echo `cat globals.lst | wc -l ` window globals used \(see globals.lst\)

echo Running all tests...
npm test -- --watchAll=false 2>&1 | tee _tests.log | grep FAIL

echo Building production...
npm run build > _build.log 2>&1

echo Lint Errors:
grep -E '(^\./|Line.*\d+)' _build.log | tee _lint.log

find . -type f > index.lst &

