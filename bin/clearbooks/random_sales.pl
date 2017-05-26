#!/usr/bin/env perl

use strict;
use warnings;
use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use File::Slurp qw(:std);

use Time::Local;
use Time::localtime;
use Time::Piece;
use Time::Seconds;

srand;

my $dict = shift || "$ENV{HOME}/bin/english/british-english-plus-names.txt";
my @words = read_file($dict);
my $DAYS = 90;


#print "words " . scalar(@words) . "\n";

sub details
{
    my $words = scalar(@words);
    my $run = 'xxx' . ('x' x int(6 * rand()));
#    print "RUN: $run\n";
    my @run = split(//, $run);
#    print Dumper(\@run);
    my $details = join(" ", map { ucfirst($words[int(rand() * $words)]) } @run);
    $details =~ s{\n}{}xmsg;
    return $details;
}

sub pad
{
    my ($value, $width) = @_;
    return ('0' x $width - length($value)) . $value;
}

for (my $sale = 0; $sale < 500; ++$sale) {
    my $amount = int(rand() * 100000) / 100;
    my $details = "S$sale: " . details();
    $details =~ s{'}{’}xmsg;

    my $rightnow = localtime;
    my $daysago = int($DAYS * rand());
    my $then = $rightnow - (ONE_DAY * $daysago);

    my $newtime = Time::Piece->new(
        timelocal(
                0,
                0,
                0,
                $then->mday,
                $then->mon - 1,
                $then->year
        ));

    my $date = $newtime->datetime;#year . '-' . pad($then->mon - 1, 2) . '-' . pad($then->mday, 2);

    my $command = qq(DATA='salesinvoice={"grossAmount":"$amount","invoiceDate":"$date","details":"$details","vatAmount":0}'; create\n);
    print $command;
}

