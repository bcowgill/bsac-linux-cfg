#!/usr/bin/env perl

# template for a perl test plan

use Test::Simple tests => 2;

ok ( 1 + 1 == 2, "should be 2" );
ok ( 1 + 12 == 2, "should be 2 also" );