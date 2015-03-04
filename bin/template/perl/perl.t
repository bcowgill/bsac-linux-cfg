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

use Test::More tests => 23;
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
	our $EXPECT = 2;
	our $EXPECT_FAIL = $EXPECT;
	our $DEEP = {};
	our $DEEP_FAIL = { this => 'that' };
	our @CAN = qw(copy move notthisone);

	if (@ARGV)
	{
		$EXPECT_FAIL = 13; # make all test pass
		$DEEP_FAIL = $DEEP;
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
	diag "Test::More use_ok() in a BEGIN block";
	# check module can be loaded
	use_ok( 'File::Copy' );
	# and specify what to export...
	use_ok( 'File::Copy' , "copy", "move" );
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

diag "can_ok() for checking method availability";
can_ok( 'File::Copy', @CAN );

#isa_ok
#new_ok
#pass
#fail
#BAIL_OUT
#subtest
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

diag "require_ok() for checking module can be required";
require_ok( 'File::Path' );
