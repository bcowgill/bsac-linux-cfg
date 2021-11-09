#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use utf8;         # so literals and identifiers can be in UTF-8
use v5.16;       # later version so we can use case folding fc() function directly
use strict;
use warnings;
use warnings  qw(FATAL utf8);   # fatalize encoding glitches
use open qw(:std :utf8);       # undeclared streams in UTF-8
use Fatal qw(open);
use English qw(-no_match_vars);
use FindBin;
use Data::Dumper;

$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = $ENV{DEBUG} || 0;
my $first_file;
my %FirstKeys; # keeps track of all keys in the first file to check duplicates.
my %First; # keeps track of the order of base keys from the first file.
my $last_global;

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] first.json second.json ...

This will reorder the keys of second.json and others based on the order found in first.json.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

Will not reorder the keys of a file named empty.json or files which are symbolic links.

Provides special ordering for keys starting with global. or pco.PARTNER. or containing .CHANGENEEDED

Keys with _confluence in the name are ignored.

See also json-plus.pl json-minus.pl json-change.sh json-insert.sh json-common.pl json-translate.pl csv2json.sh json_pp json_xs jq

Example:

$cmd src/translations/empty.json src/translations/*.json src/partnerConfigs/mastercard/translations/*.json
perl -i -pne 's{\\/}{/}xmsg' src/translations/*.json src/partnerConfigs/mastercard/translations/*.json
USAGE
	exit 0;
}

unless (scalar(@ARGV) >= 2)
{
	usage()
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

sub debug
{
	print STDERR @ARG if $DEBUG;
}

sub fatal {
  print STDERR @ARG;
  exit 1;
}

sub fatal_json {
  my ($file, $pos, $line, $message) = @ARG;
  $message ||= "Unknown JSON";
  fatal("$file: line $pos: $message: $line");
  exit 1;
}

sub pad
{
  my ($number, $places) = @ARG;
  $places = $places || 6;
  return ('0' x ($places - length($number))) . $number;
}

sub examine
{
  my ($file) = @ARG;
  print("examine $file for key order\n");
  my $fh;
  my $pos = 0;
  open($fh, "<", $file);
  while (my $line =<$fh>)
  {
    ++$pos;
    next if $line =~ m{\A\s*[{}]}xms;
    fatal_json($file, $pos, $line) unless $line =~ m{\A\s*"([^"]+)"}xms;
    my $key = $1;
    fatal_json($file, $pos, $line, "Duplicate key found.") if $FirstKeys{$key};
    $FirstKeys{$key} = 1;
    next if $key =~ m{\Apco\.}xms;
    next if $key =~ m{_confluence\z}xms;
    $First{$key} = 2 * $pos;
    $last_global = $First{$key} + 1 if $key =~ m{\Aglobal\.}xms;
  }
  close($fh);
  debug("last global: $last_global\n");
  debug("order: " . Dumper(\%First));
}

sub get_weight
{
  my ($key) = @ARG;
  my $weight;
  my $real_key = $key;
  $key =~ s{\.CHANGENEEDED}{}xms;
  if ($key =~ m{\Aglobal\.}xms)
  {
    $weight = $First{$key} ? "@{[pad($First{$key})]} $real_key" : "@{[pad($last_global)]} $real_key";
  }
  else
  {
    $weight = $First{$key} ? "@{[pad($First{$key})]} $real_key" : 0;
  }
  return $weight;
}

sub reorder
{
  my ($file) = @ARG;
  debug("reorder $file\n");
  my $fh;
  my $pos = 0;
  my %Keys;
  my %Weight;
  my %Lines;
  open($fh, "<", $file);
  while (my $line =<$fh>)
  {
    ++$pos;
    next if $line =~ m{\A\s*[{}]}xms;
    fatal_json($file, $pos, $line) unless $line =~ m{\A\s*"([^"]+)"}xms;
    my $key = $1;
    fatal_json($file, $pos, $line, "Duplicate key found.") if $Keys{$key};
    next if $key =~ m{_confluence}xms;
    $Keys{$key} = 1;
    my $show_key = $key;
    if ($key =~ m{\Apco\.([^.]+)\.(.+)\z}xms)
    {
      my ($partner, $first_key) = ($1, $2);
      $show_key = $first_key;
      my $weight = get_weight($first_key);
      $Weight{$key} = $weight ? "$partner $weight" : 0;
    }
    else
    {
      $Weight{$key} = get_weight($key);
    }
    fatal_json($file, $pos, $line, "key [$show_key] was not present in $first_file") unless $Weight{$key};
    chomp($line);
    $line =~ s{\s*,?\s*\z}{}xms;
    $Lines{$key} = "$line,\n";
  }
  close($fh);

  debug("weight: " . Dumper(\%Weight));
  my @Lines = map { $Lines{$ARG} } sort { $Weight{$a} cmp $Weight{$b} } keys(%Weight);
  if (scalar(@Lines) > 1)
  {
    print("reorder keys in $file\n");
    $Lines[-1] =~ s{\s*,\s*\z}{\n}xms;
    # debug("lines: " . Dumper(\@Lines));
    my $output = join("", "{\n", @Lines, "}\n");
    debug("output: $output");

    open($fh, ">", $file);
    print $fh $output;
    close($fh);
  }
}

sub main {
  $first_file = shift(@ARGV);
  examine($first_file);

  foreach my $file (@ARGV) {
    next if $file =~ m{empty\.json};
    next if -l $file; # skip symbolic links
    reorder($file);
  }
}

main();
