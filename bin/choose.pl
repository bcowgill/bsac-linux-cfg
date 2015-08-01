#!/usr/bin/env perl
# choose a random line from standard input
srand;
my $line;
rand($.) < 1 and ($line = $_) while <>;
print "$line";
