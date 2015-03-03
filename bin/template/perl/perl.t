#!/usr/bin/env perl

# template for a perl test plan
# ./perl.t      # to see all the tests in gory detail
# prove perl.t  # to just see summary results of tests

use Test::Simple tests => 2;

ok ( 1 + 1 == 2, "should be 2" );
ok ( 1 + 12 == 2, "should be 2 also" );