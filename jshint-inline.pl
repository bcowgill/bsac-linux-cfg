#!/usr/bin/env perl
# help to create jshint option settings
# reads in /*jshint options ... */
# and outputs a line wrapped /*jshint options ... */
# as well as an indented JSON options: { ... }
# source: https://github.com/bcowgill/jshint-test/tree/master/bin

# bin/jshint-inline.pl lib/_inline_jshint_opts.js
# bin/jshint-inline.pl lib/pref_inline_jshint_opts.js

use strict;
use warnings;
use English;
use Data::Dumper;

our $INDENT = '    ';
our $INDENT_LEN = length($INDENT);

$INDENT = "\t";
$INDENT_LEN = 4;

our $WRAP_AT = 78;

our $JSON_PREFIX = '      ';
our $JSON_INDENT = '  ';

our @HintOptions = ();
local $INPUT_RECORD_SEPARATOR = undef;

while (my $line = <>) {
   $line =~ s{
      (/\* \s* jshint \s+ ([^\*]*) \*/)
   }{
      handle_jshint_options(split(m{ \s* , \s* }xms, $2));
   }xmsge;
}

sub handle_jshint_options
{
   my @Options = @ARG;
   foreach my $option (@Options)
   {
      $option =~ s{\s* \z}{}xms;
      my ($key, $value) = split(m{\s* : \s* }xms, $option);
      my $rhOption = {
         'raw' => $option,
         'key' => $key,
         'value' => $value,
      };
      push(@HintOptions, $rhOption);
   };
}

sub output
{
   my @Output = @ARG;
   my $col = $INDENT_LEN;
   print $INDENT;

   while (scalar(@Output))
   {
      my $put = $Output[0] . (1 == scalar(@Output) ? '' : ', ');
      if ($col + length($put) > $WRAP_AT)
      {
         $col = $INDENT_LEN;
         print "\n$INDENT";
      }
      print $put;
      $col += length($put);
      shift(@Output);
   }
}

sub valueJSON
{
   my ($value) = @ARG;
   unless ($value =~ m{\A (true | false | \d+) \z}xms)
   {
      $value = "'$value'";
   }
   return $value;
}

sub outputJSON
{
   my @Output = @ARG;
   print "${JSON_PREFIX}options: {\n$JSON_PREFIX$JSON_INDENT";
   print join(",\n$JSON_PREFIX$JSON_INDENT", map { "'$ARG->{key}': @{[valueJSON($ARG->{'value'})]}" } @Output);
   print "\n${JSON_PREFIX}},\n";
}
#print Dumper(\@HintOptions);

print "/*jshint\n";
output(map { "$ARG->{'key'}: $ARG->{'value'}" } @HintOptions);
print "\n*/\n";

outputJSON(@HintOptions);
