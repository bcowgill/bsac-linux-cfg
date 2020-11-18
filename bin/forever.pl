#!/usr/bin/env perl
# output the same thing forever in 1MB chunks.
# Useful for testing file operations on a full device.
# WINDEV tool useful on windows development machine
my @default = qw(I swear by my life and my love of it never to live for the sake of another man nor ask another man to live for the sake of mine.);

my $mb = 1024 * 1024;

my $output = join(' ', @ARGV || @default) . ' ';
$output = $output x (int($mb / length($output)));

do {
	print $output;
} while (1);
