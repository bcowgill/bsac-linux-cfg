#!/usr/bin/perl -Tw
# above line to test in taint mode
#!/usr/bin/env perl
# above line for non-taint testing

# template for a perl test plan based on Test::Tutorial
# gives a full demonstration of all Test::More functionality
# perldoc Test::Tutorial
# ./perl.t; echo == $? ==        # to see all the tests in gory detail
# ./perl.t pass; echo == $? ==   # to see all the tests pass
# ./perl.t bail; echo == $? ==   # to see what BAIL_OUT does
# prove perl.t; echo == $? ==    # to just see summary results of tests
# prove ./perl.t :: pass         # pass args to test plan to make test pass
# prove ./perl.t :: bail         # pass args to test plan to BAIL_OUT

# TODO
#Test::Deep
#builder() Test::Builder access
#Test::Class xUnit like
#Test::Inline embed testing in your modules
#Bundle::Test whole bunch of test modules to install
# Test::Exception
# Test::Warn
# Test::NoWarnings

#use threads; # must precede Test::More if you are threading
use Test::Most tests => 35;
#use Test::More tests => 35;
# or if you have to calculate the number of tests
# plan tests => $number_of_tests;
# or if this test plan doesn't work on this OS
#if ( $OSNAME eq 'not this' ) {
#	plan skip_all => 'Test irrelevant on this OS';
#}
#else {
#	plan tests => 42;
#}
# or if you can't pre-calculate number of tests
# ... do all testing
# done_testing($number_of_tests_if_known);

# because all good code starts with...
#use strict; # not needed Test::Most does this
#use warnings; # not needed Test::Most does this
use English -no_match_vars;

use utf8; # if Test::Difference used on unicode text

our $ALL_PASS = 0;
our $BAIL = 0;
our $SUBTEST = 'main';
our $DEEP = {};
our $EXPECT = 2;
our $EXPECT_FAIL = $EXPECT;
our $DEEP_FAIL = { this => 'that' };
our $ISA = 'FileHandle';
our $ISA_FAIL = 'Thingie';
our @USE = qw(Cwd This/one/is/gone);
our @CAN = qw(copy move not_this_one);

# Test::Exception, Test::Differences, Test::Deep and Test::Warn are included by Test::Most
our @MODULES = qw(
	Test::Differences
	Test::Deep
	Test::Exception
	Test::Class
	Test::Inline
	Test::Warn
	Test::NoWarnings
);
our %HAS_MODULE = ();

# Construct a few lines of random text for testing
our $BIG_TEXT = join(
	"",
	map { $ARG =~ s{ 9 [04] }{\n}xmsg; $ARG; }
	map { rand($ARG); } (1 .. 20));
$BIG_TEXT =~ s{([^\n]{50})}{$1\n}xmsg;
our $BIG_TEXT_FAIL = $BIG_TEXT;
	$BIG_TEXT_FAIL =~ s{ 3 ([72]) }{${1}3}xmsg;
	$BIG_TEXT_FAIL = "a$BIG_TEXT_FAIL";

# Construct a structure for testing deep comparisons
our $STRUCT = {
	'key' => 'value',
	'arr' => [1,2,3,4,5],
	'obj' => { 'k' => 'v', 'j' => 'k', 'm' => 'n' },
};
our $STRUCT_FAIL = {
	'key' => 'value',
	'arr' => [1,2,5,4,5,42],
	'another' => 'val',
	'obj' => { 'k' => 'v', 'm' => 'n', 'z' => 'p' },
};

if (@ARGV)
{
	my $mode = shift;
	if ($mode eq 'bail')
	{
		$BAIL = 1;
	}
	else
	{
		$ALL_PASS = 1;
		$EXPECT_FAIL = 13; # make all test pass
		$DEEP_FAIL = $DEEP;
		$ISA_FAIL = $ISA;
		$BIG_TEXT_FAIL = $BIG_TEXT;
		$STRUCT_FAIL = $STRUCT;
		pop(@USE);
		push(@USE, 'Data::Dumper');
		pop(@CAN);
	}
}

BEGIN {
	# Test::Differences to make unicode diffs better
	# before loading Test::Differences
	$ENV{DIFF_OUTPUT_UNICODE} = 1
}

BEGIN {
	# handle utf8 characters to avoid Wide character in print errors
	my $builder = Test::More->builder;
	binmode $builder->output,         ":utf8";
	binmode $builder->failure_output, ":utf8";
	binmode $builder->todo_output,    ":utf8";
}

diag "Test::Simple ok() only";
ok ( 1 + 1 == $EXPECT );
ok ( 1 + 1 == $EXPECT, "should be $EXPECT" );
ok ( 1 + 12 == $EXPECT_FAIL, "should be $EXPECT also" )
  or diag("some diagnosis on failure of test...");

diag("Test::More note() diag() explain() for diagnostics");
note "note() - does not show in when running in a harness";
note("i am invisible in the harness (or prove) but not when running normally");
diag "diag() - shows message always";
ok(1 + 12 == $EXPECT_FAIL)
	|| map { diag($ARG) } (
	'array = ',
	explain [qw(explain() dumps structures nicely)]
);

BEGIN {
	$SUBTEST = "Test::More use_ok() in a BEGIN block ";
	subtest $SUBTEST => sub
	{
		plan tests => 3;

		note "use_ok() cannot specify a test message";
		note "use module with default methods import";
		use_ok( 'FileHandle' );
		note "use module and specify specific methods to import";
		use_ok( 'File::Copy' , "copy", "move" );
		note "use module and prevent any methods from being imported";
		require_ok( 'File::Slurp' ); # will not import read_file function
		note "end subtest $SUBTEST";
	}
}

diag "Test::More pass()/fail() for absolute control";
pass("pass() - some test passed");
if ($ALL_PASS)
{
	pass("fail() - some test failed - not now");
}
else
{
	fail("fail() - some test failed");
}

diag "Test::More adds is()/isnt() uses eq and ne operators, not good for true/false checks, use ok() for that";
is ( 1 + 1, $EXPECT);
is ( 1 + 1, $EXPECT, "should be $EXPECT");
isnt ( 1 + 1, $EXPECT_FAIL, "should be $EXPECT also");
my $not_me;
is ($not_me, undef, "should be undefined ");

diag "like()/unlike() for regex match";
like ( 'result', qr{esu}, "should match esu" );
unlike ( 'result', qr{ESU}, "should not match ESU" );

diag "cmp_ok() for any comparison operator";
cmp_ok(1 + 1, '==', $EXPECT, "should be $EXPECT");
cmp_ok(1 + 12, '==', $EXPECT_FAIL, "should be $EXPECT also");
cmp_ok(2, '<', $EXPECT_FAIL, "should be less than $EXPECT");

diag "is_deeply() for deep structure comparison";
is_deeply({}, $DEEP, "should be identical objects");
is_deeply({}, $DEEP_FAIL, "should be identical objects")
   or diag explain $DEEP_FAIL;

# dump an object for putting it into the test plan as data/expected result
#dumpForDeep(\@MODULES);

diag "subtest() to run a set of tests as a sub-test nicely indented";

subtest 'subtest() with plan skip_all' => sub {
	plan skip_all => 'cuz I said so';
	pass('this test will never be run');
};

$SUBTEST = "Object Oriented testing methods";
my $passed = subtest $SUBTEST => sub
{
	plan tests => 8 + scalar(@MODULES);

	diag "require_ok() for checking module can be required - will not import any symbols";
	require_ok( 'File::Path' );

	foreach my $module (@MODULES)
	{
		$module = $ALL_PASS ? 'Test::More' : $module;
		$HAS_MODULE{$module} = use_ok($module);
	}
	diag explain \%HAS_MODULE;

	diag "isa_ok() - was something created of a given type";
	my $fh = FileHandle->new($PROGRAM_NAME,"r");
	isa_ok([], 'ARRAY', "should be ARRAY");
	isa_ok($fh, $ISA);
	isa_ok($fh, $ISA_FAIL, "should be FileHandle");

	diag "can_ok() for checking method availability on module or object - cannot specify a custom message";
	can_ok( 'File::Copy', @CAN );
	can_ok( $fh, 'new' );

	if ($ALL_PASS) {
		can_ok(__PACKAGE__, 'copy'); # imported from File::Copy
	}
	else
	{
		note "can_ok() read_file fails because we required File::Slurp instead of used it above";
		can_ok(__PACKAGE__, 'read_file');
	}

	diag "new_ok() create object and check class type all in one go";
	$fh->close();
	$fh = new_ok(
		'FileHandle'     # class to instantiate from
		=> [$PROGRAM_NAME, "r"],  # params to FileHandle->new()
		'should be FileHandle'    # object name/test message
	);

	diag "BAIL_OUT() in a subtest will also abort the whole plan not just the sub test";
	diag "end subtest $SUBTEST";
}; # subtest Object Oriented
diag "subtest() return val can be checked did it pass? $passed";

diag "skip() and TODO for broken and unimplemented tests";
SKIP: {
	my $SKIP_TESTS = 2; # two tests to skip
	skip(
		'not going to work on this OS',
		$SKIP_TESTS)
		unless $OSNAME eq 'not this';

	# tests don't run and don't count as failures
	is('some', 'test', 'unsupported on this OS');
	is('some', 'test', 'unsupported on this OS');

	die "horribly, see never gets here it is totally skipped";
}

diag "TODO: runs tests but expect to fail";
TODO: {
	local $TODO = "flibble() not yet implemented";

	# the tests run, look like failures but don't count as failures overall
	is('flibble', 'something', 'flibble should be something');
	is('flibble', 'flibble', 'flibble should be flibble');
}

diag "todo_skip: when you can't even run the TODO tests to see if they fail, this will skip them";
TODO: {
	local $TODO = "waffle() just crashes and burns";
	my $SKIP_TESTS = 2; # two tests to skip
	todo_skip(
		$TODO,
		$SKIP_TESTS)
		unless $OSNAME eq 'not this';

	# the tests DIE HORRIBLY if run, so we skip but know they are TODO
	is([die, die, die], 'something', 'waffle should be something');
	is('waffle', 'waffle', 'waffle should be waffle');
}

$SUBTEST = "Test::Differences";
subtest $SUBTEST => sub
{
	diag "$SUBTEST - for comparing bodies of text, deep structures or SQL records";
	test_or_skip($SUBTEST, 12);

	# Docs http://search.cpan.org/~dcantrell/Test-Differences-0.63/lib/Test/Differences.pm

	# Needed if diffing unicode text
	# use utf8;
	# BEGIN { $ENV{DIFF_OUTPUT_UNICODE} = 1; use Test::Differences; }
	my $want_utf = { 'Traditional Chinese' => '中國' };

	my $have_utf = { 'Traditional Chinese' => '中国' };

	if ($ALL_PASS) {
		$want_utf = $have_utf;
	}

	eq_or_diff($have_utf, $want_utf, 'eq_or_diff() should do Unicode, baby');

	diag "comparison of Test::More handling of big text vs Test::Differences";
	is_deeply($BIG_TEXT, $BIG_TEXT_FAIL, "Test::More is_deeply() for text comparison");
	is_deeply($STRUCT, $STRUCT_FAIL, "Test::More is_deeply() for structure comparison");

	# this is the default and does not need to explicitly set unless you need
	# to reset it back from another diff type
	table_diff();
	eq_or_diff_text($BIG_TEXT, $BIG_TEXT_FAIL, 'eq_or_diff_text() (lines count from 1) example table diff of text');
	eq_or_diff_data($BIG_TEXT, $BIG_TEXT_FAIL, 'eq_or_diff_data() (lines count from 0) example table diff of text');
	eq_or_diff($STRUCT, $STRUCT_FAIL, 'eq_or_diff() example table diff of a perl structure');

	unified_diff();
	eq_or_diff($BIG_TEXT, $BIG_TEXT_FAIL, 'eq_or_diff() example unified diff');
	eq_or_diff($STRUCT, $STRUCT_FAIL, 'eq_or_diff() example unified diff of a perl structure');

	context_diff();
	eq_or_diff($BIG_TEXT, $BIG_TEXT_FAIL, 'eq_or_diff() example context diff');
	eq_or_diff($STRUCT, $STRUCT_FAIL, 'eq_or_diff() example context diff of a perl structure');

	oldstyle_diff();
	eq_or_diff($BIG_TEXT, $BIG_TEXT_FAIL, 'eq_or_diff() example oldstyle diff');
	eq_or_diff($STRUCT, $STRUCT_FAIL, 'eq_or_diff() example oldstyle diff of a perl structure - note very good');

};

$SUBTEST = "Test::Deep";
subtest $SUBTEST => sub
{
	diag "$SUBTEST - for data structures with regex checking of items";
	test_or_skip($SUBTEST, 1);

	#TODO http://search.cpan.org/~rjbs/Test-Deep-0.115/lib/Test/Deep.pm#Without_Test::Deep

	my $rhPerson = {
		Name => 'Mister Johnson',
		Phone => '054322334',
		Difficult => 'value varies and is too difficult to validate here',
		ChildNames => ['peter', 'Mr paul', 'Miss mary']
	};
	if ($ALL_PASS) {
		$rhPerson->{Name} = 'Mr Johnson';
		shift(@{$rhPerson->{ChildNames}});
	}

	my $name_re = re('^(Mr|Mrs|Miss) \w+ \w+$');
	cmp_deeply(
		$rhPerson,
		{
			Name => $name_re,
			Phone => re('^0d{6}$'),
			ChildNames => array_each($name_re),
			Difficult => ignore()
		},
		"cmp_deeply()/re()/array_each() - deep validation of structured data"
	);

	# cmp_bag()
	# cmp_set()
	# cmp_methods()
	# eq_deeply()
	# cmp_details()
	# deep_diag()
	# all()
	# any()
	# code()

	# scalar checks
	# ignore()
	# re()
	# str()
	# num()
	# bool()

	# ref checks
	# shallow()
	# noclass()
	# useclass()
	# isa() or Isa()

	# array checks
	# array_each()
	# bag()
	# set()
	# noneof()
	# superbagof()
	# subbagof()
	# supersetof()
	# subsetof()

	# hash/obj checks
	# obj_isa()
	# hash_each()
	# superhashof()
	# subhashof()

	# methods()
	# listmethods()

	ok(1, "$SUBTEST test");
};

$SUBTEST = "Test::Exception";
subtest $SUBTEST => sub
{
	test_or_skip($SUBTEST, 1);
	sub death { die 'I have died!'; };
	sub simple_death { die Error::Simple->new('i die') };
	sub life { return 'I live!';};

	#TODO http://search.cpan.org/~ether/Test-Exception-0.38/lib/Test/Exception.pm

	throws_ok { return life() } qr/division by zero/, 'throws_ok() should be division by zero';
	throws_ok { return 42 / 0 } qr/division by zero/, 'throws_ok() match against stringified exception';
	# $@ $EVAL_ERROR are preserved after throws_ok() so you can do further processing
	note explain $EVAL_ERROR;
	throws_ok { return death(); } 'Error::Simple', 'throws_ok() match against error class name';
	throws_ok { return death(); } Error::Simple->new(), 'throws_ok() match against instance of the exception';
	diag 'throws_ok() with no test message given';
	throws_ok { return simple_death(); } 'what';

	dies_ok { return life(); } 'dies_ok() should die in some manner';
	lives_ok(sub { return death(); }, 'lives_ok() should not die');
	lives_and {
		is(death(), 'I live!', 'should return string');
	} 'lives_and() should not die and allows further testing';

	ok(1, "$SUBTEST test");
};

$SUBTEST = "Test::Inline";
subtest $SUBTEST => sub
{
	test_or_skip($SUBTEST, 1);
	ok(1, "$SUBTEST test");
};

$SUBTEST = "Test::Class";
subtest $SUBTEST => sub
{
	test_or_skip($SUBTEST, 1);
	ok(1, "$SUBTEST test");
};

$SUBTEST = "Test::Warn";
subtest $SUBTEST => sub
{
	test_or_skip($SUBTEST, 1);
	ok(1, "$SUBTEST test");
};

$SUBTEST = "Test::NoWarnings";
subtest $SUBTEST => sub
{
	test_or_skip($SUBTEST, 1);
	ok(1, "$SUBTEST test");
};

diag "BAIL_OUT() abort test plan if cannot carry on -- doesn't give an ending summary when in harness";
# stop testing if any of your modules will not load
for my $module (@USE) {
	require_ok $module or ($BAIL && BAIL_OUT "Can't load $module");
}

# Conditional subtests, test or skip based on existence of a module
sub test_or_skip
{
	my ($module, $tests) = @ARG;
	if ($HAS_MODULE{$module}) {
		plan tests => $tests;
	}
	else
	{
		plan skip_all => "module $module unavailable";
	}
}

# Dump some object for use as base data in a
# Test::Deep cmp_deeply comparison
# or Test::More is_deeply test
sub dumpForDeep
{
	my $obj = shift;

	use Data::Dumper;

	local $Data::Dumper::Sortkeys = 1;
	local $Data::Dumper::Indent = 1;
	local $Data::Dumper::Terse = 1;

	print Dumper($obj);
}

