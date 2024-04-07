#!/usr/bin/env perl
# explain Perl's special variables with English variable names and comments.
# will add a comment to the end of a line with a single special variable on it
# and will add a number of comment lines above a line with multiple special variables in it.
# because of perl's rich syntax a script amended by this progam could end up broken, so if
# you use it to document a script, make sure you have a backup and test it before you commit to use the new amended script.
#
# use command 'perldoc perlvars' for more details about these variables

use warnings;
use strict;
use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

my $DEBUG = 0;
my @reVars = ();
my $reVars = "";
my %Vars = ();

while (my $data = <DATA>)
{
	chomp($data);
	next if $data =~ m{\A\s*(\#|\z)}xms;

	my ($config, $comment) = split(/\s*\|\|\s*/xms, $data);
	$config ||= "";
	$comment ||= "";

	my ($var, $english, $short) = split(/\s+/xms, $config);
	$var ||= "";
	$english ||= "";
	$short ||= "";
	next if $var eq "";

	my $reVar = quotemeta($var);
	$reVar = '\b' . $reVar if ($reVar =~ m{\A[A-Z]}xms);
	$reVar .= '\b' if ($reVar =~ m{[A-Z]\z}xms);
	push(@reVars, $reVar);
	print qq{$var / $english / $short / $comment\n} if $DEBUG;
	$Vars{$reVar} = {
		var => $var,
		re => $reVar,
		english => $english,
		short => $short,
		comment => $comment,
		help => trim(join(' ', ('#', $var, '=', $short, $english, $comment))),
	};
}

print Dumper(\%Vars) if $DEBUG;

$reVars = '(' . join('|', sort { length($b) <=> length($a)  } @reVars) . ')';
$reVars = qr{$reVars}xms;
print qq{reVars: $reVars\n} if $DEBUG;

while (my $line = <>)
{
	if ($line =~ $reVars)
	{
		my @Help = ();
		$line =~ s{$reVars}{push(@Help, $Vars{quotemeta($1)}{help}); $1}xmsge;
		if (scalar(@Help) > 1)
		{
			$line =~ m{\A(\s*)}xms;
			my $indent = $1;
			print join("", map { "$indent$ARG\n" } @Help);
			print $line;
		}
		else
		{
			chomp($line);
			print "$line $Help[0]\n";
		}
	}
	else
	{
		print $line;
	}
}

sub trim
{
	my ($str) = @ARG;
	$str =~ s{\s\s+}{ }xmsg;
	return $str;
}

__DATA__
$_ $ARG
@_ @ARG
$" $LIST_SEPARATOR
$$ $PROCESS_ID $PID
$0 $PROGRAM_NAME
$( $REAL_GROUP_ID $GID
$) $EFFECTIVE_GROUP_ID $EGID
$< $REAL_USER_ID $UID
$> $EFFECTIVE_USER_ID $EUID
$; $SUBSCRIPT_SEPARATOR $SUBSEP
$a || sort comparison first value
$b || sort comparison second value
$^F $SYSTEM_FD_MAX
@F || autosplit fields of current line read in
$^I $INPLACE_EDIT
$^M || emergency memory pool
$^O $OSNAME
$^T $BASETIME
$^V $PERL_VERSION
$^X $EXECUTABLE_NAME
$1 || first matched () value in regular expression
$2 || second matched () value in regular expression
$3 || third matched () value in regular expression
$4 || fourth matched () value in regular expression
$5 || fifth matched () value in regular expression
$6 || sixth matched () value in regular expression
$7 || seventh matched () value in regular expression
$8 || eighth matched () value in regular expression
$9 || ninth matched () value in regular expression
$10 || tenth matched () value in regular expression
$11 || eleventh matched () value in regular expression
$12 || twelfth matched () value in regular expression
$13 || thirteenth matched () value in regular expression
$14 || fourteenth matched () value in regular expression
$15 || fifteenth matched () value in regular expression
$16 || sixteenth matched () value in regular expression
$17 || seventeenth matched () value in regular expression
$18 || eighteenth matched () value in regular expression
$19 || nineteenth matched () value in regular expression
$20 || twentieth matched () value in regular expression
$& $MATCH || prefer ${^MATCH}
${^MATCH} || string that was matched by regular expression
$` $PREMATCH || prefer ${^PREMATCH}
${^PREMATCH} || string preceding what was matched by regular expression
$' $POSTMATCH || prefer ${^POSTMATCH}
${^POSTMATCH} || string following what was matched by regular expression
$+ $LAST_PAREN_MATCH
$^N $LAST_SUBMATCH_RESULT
@+ @LAST_MATCH_END
%+ %LAST_PAREN_MATCH
@- @LAST_MATCH_START
%- %LAST_MATCH_START
$^R $LAST_REGEXP_CODE_RESULT
${^RE_DEBUG_FLAGS} || current value of regex debug flags
${^RE_TRIE_MAXBUF} || controls how certain regex optimisations are applied and how much memory they utilize
$, $OUTPUT_FIELD_SEPARATOR $OFS
$. $INPUT_LINE_NUMBER $NR
$/ $INPUT_RECORD_SEPARATOR $RS
$\ $OUTPUT_RECORD_SEPARATOR $ORS
$| $OUTPUT_AUTOFLUSH
$^A $ACCUMULATOR
$^L $FORMAT_FORMFEED
$% $FORMAT_PAGE_NUMBER
$- $FORMAT_LINES_LEFT
$: $FORMAT_LINE_BREAK_CHARACTERS
$= $FORMAT_LINES_PER_PAGE
$^ $FORMAT_TOP_NAME
$~ $FORMAT_NAME
$^E $EXTENDED_OS_ERROR
$^S $EXCEPTIONS_BEING_CAUGHT
$^W $WARNING
$! $OS_ERROR $ERRNO
%! %OS_ERROR %ERRNO
$? $CHILD_ERROR
$@ $EVAL_ERROR
$^C $COMPILING
$^D $DEBUGGING
$^H || internal compile-time hints for the interpreter
%^H || internal lexically scoped pragmas
$^P $PERLDB || internal variable for debugging support
$# $OFMT || deprecated was used to format printed numbers
$* || deprecated was used to enable multiline matching
$[ $ARRAY_BASE || deprecated was used to specify the base index of arrays and strings
$] $OLD_PERL_VERSION || deprecated was used for the perl version number
%ENV || shell environment variables
@INC || path search order for including libraries into the script
%INC || each file included in the script mapped to the location they were found in
%SIG || signal handler mapping
${^WIN32_SLOPPY_STAT} || faster but more inaccurate stat() funcion for Windows
$ARGV || name of current file reading from <>
<> || angle operator reads the contents of standard input or the files listed on the command line
<=> || space ship operator returns -1, 0 or 1 by comparing the numbers on either side of it
@ARGV || command line arguments provided to the script
ARGV || the file handle that <> uses
ARGVOUT || the file handle used when inplace edit was specified by -i on the command line
${^LAST_FH} || reference to the last read file handle
${^CHILD_ERROR_NATIVE} || native status returned by the lasts pipe close or other child process
${^WARNING_BITS} || current set of warning checks enabled by the "use warnings" pragma
${^ENCODING} || reference to the "Encode" object that is used to convert the source code to Unicode
${^GLOBAL_PHASE} || current phase of the perl interpreter
${^OPEN} || internal variable used by PerlIO
${^TAINT} || reflects if taint mode is on or off from command line -t, -T or -TU flags
${^UNICODE} || reflects certain Unicode settings of Perl from command line -C options
${^UTF8CACHE} || controls the state of the internal UTF-8 offset caching code
${^UTF8LOCALE} || indicates whether a UTF-8 locale was detected by perl at startup
