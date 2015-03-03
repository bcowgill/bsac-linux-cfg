#!/usr/bin/env perl

# template for a perl test plan based on Test::Tutorial
# perldoc Test::Tutorial
# ./perl.t; echo == $? ==        # to see all the tests in gory detail
# ./perl.t pass; echo == $? ==   # to see the tests pass
# prove perl.t; echo == $? ==    # to just see summary results of tests
# prove ./perl.t :: pass         # pass args to test plan to make test pass


use Test::More tests => 9;

our $EXPECT = 2;
our $EXPECT_FAIL = $EXPECT;

if (@ARGV)
{
	$EXPECT_FAIL = 13; # make all test pass
}

# Test::Simple ok() only

diag "Test::Simple";
ok ( 1 + 1 == $EXPECT );
ok ( 1 + 1 == $EXPECT, "should be $EXPECT" );
ok ( 1 + 12 == $EXPECT_FAIL, "should be $EXPECT also" );

# Test::More adds is()

diag "Test::More";
is ( 1 + 1, $EXPECT);
is ( 1 + 1, $EXPECT, "should be $EXPECT");
is ( 1 + 12, $EXPECT_FAIL, "should be $EXPECT also");

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
}
