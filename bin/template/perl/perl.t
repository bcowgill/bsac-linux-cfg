#!/usr/bin/perl -Tw
# above line to test in taint mode
#!/usr/bin/env perl
# above line for non-taint testing

# template for a perl test plan based on Test::Tutorial
# perldoc Test::Tutorial
# ./perl.t; echo == $? ==        # to see all the tests in gory detail
# ./perl.t pass; echo == $? ==   # to see the tests pass
# prove perl.t; echo == $? ==    # to just see summary results of tests
# prove ./perl.t :: pass         # pass args to test plan to make test pass

use Test::More tests => 25;
# or if you have to calculate the number of tests
# plan tests => $number_of_tests;
# or if this test plan doesn't work on this OS
#if ( $^O eq 'not this' ) {
#	plan skip_all => 'Test irrelevant on this OS';
#}
#else {
#	plan tests => 42;
#}
# or if you can't pre-calculate number of tests
# ... do all testing
# done_testing($number_of_tests_if_known);

BEGIN {
	our $SUBTEST = 'main';
	our $ALL_PASS = 0;
	our $EXPECT = 2;
	our $EXPECT_FAIL = $EXPECT;
	our $DEEP = {};
	our $DEEP_FAIL = { this => 'that' };
	our $ISA = 'FileHandle';
	our $ISA_FAIL = 'Thingie';
	our @USE = qw(Cwd This/one/is/gone);
	our @CAN = qw(copy move not_this_one);

	if (@ARGV)
	{
		$ALL_PASS = 1;
		$EXPECT_FAIL = 13; # make all test pass
		$DEEP_FAIL = $DEEP;
		$ISA_FAIL = $ISA;
		pop(@USE);
		push(@USE, 'Data::Dumper');
		pop(@CAN);
	}
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
	|| map { diag($_) } (
	'array = ',
	explain [qw(explain() dumps structures nicely)]
);

BEGIN {
	$SUBTEST = "Test::More use_ok() in a BEGIN block ";
	subtest $SUBTEST => sub
	{
		plan tests => 2;

		note "use_ok() cannot specify a test message";
		use_ok( 'FileHandle' );
		# and specify what to export...
		use_ok( 'File::Copy' , "copy", "move" );
		note "end subtest $SUBTEST";
	}
}

diag "Test::More pass()/fail() for absolute control";
pass("some test passed");
if ($ALL_PASS)
{
	pass("some test failed - not now");
}
else
{
	fail("some test failed");
}

diag "Test::More adds is()/isnt() uses eq and ne operators, not good for true/false checks, use ok() for that";
is ( 1 + 1, $EXPECT);
is ( 1 + 1, $EXPECT, "should be $EXPECT");
isnt ( 1 + 1, $EXPECT_FAIL, "should be $EXPECT also");
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

diag "subtest() to run a set of tests as a sub-test nicely indented";

$SUBTEST = "Object Oriented testing methods";
subtest $SUBTEST => sub
{
	plan tests => 7;

	diag "require_ok() for checking module can be required";
	require_ok( 'File::Path' );

	diag "isa_ok() - was something created of a given type";
	my $fh = FileHandle->new($0,"r");
	isa_ok([], 'ARRAY', "should be ARRAY");
	isa_ok($fh, $ISA);
	isa_ok($fh, $ISA_FAIL, "should be FileHandle");

	diag "can_ok() for checking method availability on module or object - cannot specify a custom message";
	can_ok( 'File::Copy', @CAN );
	can_ok( $fh, 'new' );

	diag "new_ok() create object and check class type all in one go";
	$fh->close();
	$fh = new_ok(
		'FileHandle'     # class to instantiate from
		=> [$0, "r"],    # params to FileHandle->new()
		'should be FileHandle'    # object name/test message
	);

	diag "BAIL_OUT() in a subtest will also abort the whole plan not just the sub test";
	diag "end subtest $SUBTEST";
}; # subtest Object Oriented

#Test::Differences
#Test::Deep

diag "skip() and TODO for broken and unimplemented tests";
SKIP: {
	my $SKIP_TESTS = 2; # two tests to skip
	skip('not going to work on this OS', $SKIP_TESTS) unless $^O eq 'not this';

	# tests don't run and don't count as failures
	is('some', 'test', 'unsupported on this OS');
	is('some', 'test', 'unsupported on this OS');

	die "horribly, see never gets here it is totally skipped";
}

TODO: {
	local $TODO = "flibble() not yet implemented";

    # the tests run, look like failures but don't count as failures overall
	is('flibble', 'something', 'flibble should be something');
	is('flibble', 'flibble', 'flibble should be flibble');
}

#todo_skip()

diag "BAIL_OUT() abort test plan if cannot carry on";
# stop testing if any of your modules will not load
for my $module (@USE) {
	require_ok $module or BAIL_OUT "Can't load $module";
}
