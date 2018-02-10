#!/usr/bin/env perl
# show or strip comments from source code

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use open IN => ':raw';

my $bl = qr{(\A|\n)}xms;
my $el = qr{(\z|\n)}xms;

my $STRIP = 0;
my $SHOW = 'kept';
my $JAVADOC = ''; # or strict or undefined
my %Keep = (
	eslint => 1,
	jslint => 0,
	jshint => 0,
	jscs => 0,
	istanbul => 0,
	prettier => 1,
);

sub usage
{
	my ($message) = @ARG;
	print "$message\n\n" if ($message);
	print <<"USAGE";
usage: $0 [--help] filename...

Strips out C/C++ style comments from source code in files specified.

--show will show the comments which would be stripped, but leaves them in place.
--keep will show the comments which are kept, without stripping anything from the file.
--eslint or --noeslint allows or strips eslint directive comments
--jslint or --nojslint allows or strips jslint directive comments
--jshint or --nojshint allows or strips jshint directive comments
--jscs   or --nojscs allows or strips jscs directive comments
--istanbul or --noistanbul allows or strips istanbul directive comments
--prettier or --prettier allows or strips prettier directive comments
--nojavadoc or --javadoc=strip strips out all javadoc comments
--javadoc or --javadoc=strictc  allows only javadoc comments with a \@word reference in them
--javadoc=lite allows all javadoc comments

Allows a single comment block at top of file.  Strips all other comments which do not begin with an apology.  By default allows eslint and prettier comment directives.
USAGE
	exit ($message ? 1 : 0);
}

if (scalar(@ARGV) && $ARGV[0] eq '--help')
{
	usage();
}

while (scalar(@ARGV) && $ARGV[0] =~ m{\A --}xms)
{
	my $option = shift(@ARGV);
	if ($option eq '--show')
	{
		$STRIP = 0;
		$SHOW = 'stripped';
	}
	elsif ($option eq '--keep')
	{
		$STRIP = 0;
		$SHOW = 'kept';
	}
	elsif ($option =~ m{\A --(no)?((esl|jsl|jsh)int|jscs|istanbul|prettier)}xms)
	{
		if (exists($Keep{$2}))
		{
			$Keep{$2} = ($1 ? 0 : 1);
		}
		else
		{
			usage("Invalid option $option");
		}
	}
	elsif ($option =~ m{\A --(no)?javadoc(=(strip|strict|lite))?}xms)
	{
		if ($1 || $3 eq 'strip')
		{
			$JAVADOC = '';
		}
		elsif ($3)
		{
			$JAVADOC = $3;
		}
		else
		{
			$JAVADOC = 'strict';
		}
	}
	else
	{
		usage("Invalid option $option");
	}
}

local $INPUT_RECORD_SEPARATOR = undef;

my $file = <>;
my @comments = ();
my @keep_comments = ();

my $KEEP_RE = join('|', grep { $Keep{$ARG} } keys(%Keep));
$KEEP_RE = "|$KEEP_RE" if length($KEEP_RE);

sub grab_it
{
  my ($string, $re) = @ARG;
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
  my ($prespace, $comment, $space, $message) = @ARG;
  my $punct = '';
  my $comma = qr{[,:\.]}xms;
  ($punct, $message) = grab_it($message, qr{\A([^a-z0-9\s]+ \s*)}xms);

  if ($message =~ m{ \A (sorry$comma|apologies$comma$KEEP_RE) }xms)
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
  my ($prespace, $comment, $space, $message, $with)  = @ARG;
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
