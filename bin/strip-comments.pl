#!/usr/bin/env perl
use strict;
use warnings;
local $/ = undef;
my $file = <>;
my @comments = ();
my @keep_comments = ();
my $bl = qr{(\A|\n)}xms;
my $el = qr{(\z|\n)}xms;

# TODO command line args to turn these on/off
my $STRIP = 0;
my $SHOW = 'kept';
my $KEEP_ESLINT = "|eslint";
my $KEEP_JSLINT = "|jslint";
my $KEEP_JSHINT = "|jshint";
my $KEEP_JSCS = "|jscs";
my $KEEP_ISTANBUL = "|istanbul";
my $KEEP_PRETTIER = "|prettier";
my $JAVADOC = ''; # or strict or undefined

# allow a single comment block at top of file
# strip all other comments which do not begin with an apology
# optionally allow js/eslint comments
# optionally allow coverage comments
# optionally allow javadoc/jsdoc

sub grab_it
{
  my ($string, $re) = @_;
  my $got = '';
  if ($string =~ m{$re}xms)
  {
    $string =~ s{$re}{}xms;
    $got = defined($1) ? $1 : '';
  }
  return ($got, $string);
}

sub keep_comment
{
  my ($prespace, $comment, $space, $message) = @_;
  my $punct = '';
  my $comma = qr{[,:\.]}xms;
  ($punct, $message) = grab_it($message, qr{\A([^a-z0-9\s]+ \s*)}xms);

  if ($message =~ m{ \A (sorry$comma|apologies$comma$KEEP_ESLINT$KEEP_JSLINT$KEEP_JSHINT$KEEP_JSCS$KEEP_ISTANBUL$KEEP_PRETTIER) }xms)
  {
    return 1;
  }
  if ($message =~ m{ \A (sorry|apologies)[,:\.] }xms)
  {
    return 1;
  }
  if ($punct =~ m{\A \* \s*}xms)
  {
    if ($JAVADOC eq "strict")
    {
      return ($message =~ m{\@\w+}xms);
    }
    elsif ($JAVADOC)
    {
      return 1;
    }
  }

  return 0;
}

sub replace_comment
{
  my ($prespace, $comment, $space, $message, $with)  = @_;
  my $replace;
  if (keep_comment($prespace, $comment, $space, $message))
  {
    $replace = $prespace . $comment;
    push(@keep_comments, $comment);
  }
  else
  {
    $replace = $with || "";
    push(@comments, $comment);
  }
  return $replace;
}

my $top_comment;
($top_comment, $file) = grab_it($file, qr{ \A ( (\s*) (// [^\n]* $el)+ ) }xms);
#print "tc1: $top_comment\n[$file]\n";
($top_comment, $file) = grab_it($file, qr{ \A ( (\s*) (/\* .*? \*/) ) }xms) unless $top_comment;
#print "tc2: $top_comment\n[$file]\n";
if ($top_comment)
{
  push(@keep_comments, $top_comment);
}

# /***** something ******/
# /* sorry, this is ok... */
$file =~ s{
  (\s*)
  (/\*
    (\s*)
    (.*?)
  \*/)
  }{
  my ($prespace, $comment, $space, $message) = ($1, $2, $3, $4);
  replace_comment($prespace, $comment, $space, $message);
}xmsgei;

$file =~ s{
  (\s*)
  (// ([^\n]* \n))
  }{
  my ($prespace, $comment, $message) = ($1, $2, $3);
  my $space;
  ($space, $message) = grab_it($message, qr{\A (\s+)}xms);
  replace_comment($prespace, $comment, $space, $message, "\n");
}xmsgei;

if ($STRIP)
{
  print "$top_comment$file\n";
}
elsif ($SHOW eq 'kept')
{
  print join("\n", @keep_comments);
}
else
{
  print join("\n", @comments);
}
