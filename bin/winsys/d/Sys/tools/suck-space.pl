#!/usr/bin/perl

my $kb = "KB" x 512;
my $MB = $kb x 1024;

my $out_MB = 256;
my $out = 0;

my $content= "";

my $start = time();
while ($out++ < $out_MB) {
#   print $MB;
$content .= $MB
}
my $stop = time();
my $seconds = $stop - $start;

print STDERR "It took $seconds seconds to output $out_MB MB\n";
