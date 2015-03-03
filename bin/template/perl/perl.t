#!/usr/bin/env perl

# template for a perl test plan based on Test::Tutorial
# perldoc Test::Tutorial
# ./perl.t      # to see all the tests in gory detail
# prove perl.t  # to just see summary results of tests

use Test::More tests => 8;

our $EXPECT = 2;

# Test::Simple ok() only

diag "Test::Simple";
ok ( 1 + 1 == $EXPECT );
ok ( 1 + 1 == $EXPECT, "should be $EXPECT" );
ok ( 1 + 12 == $EXPECT, "should be $EXPECT also" );

# Test::More adds is()

diag "Test::More";
is ( 1 + 1, $EXPECT);
is ( 1 + 1, $EXPECT, "should be $EXPECT");
is ( 1 + 12, $EXPECT, "should be $EXPECT also");

SKIP: {
	my $SKIP_TESTS = 2; # one test to skip
	skip('not on this OS', $SKIP_TESTS) unless $^O eq 'not this';

	is('some', 'test', 'unsupported on this OS');
	is('some', 'test', 'unsupported on this OS');

	die "horribly, see never gets here it is totally skipped";
}
