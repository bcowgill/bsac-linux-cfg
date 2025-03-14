#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

=head1 NAME

ls-tabs.pl - List tab and space inconsistencies in files

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

ls-tabs.pl [options] [@options-file ...] [file ...]

List tab and space inconsistencies in files and optionally show long line histogram.

	Options:
		--spaces=N       optional. number of spaces per tab stop. default 4
		--maxlen=N       optional. desired maximum line length. shows breakdown of longer lines.
		--version        display program version
		--help -?        brief help message
		--man            full help message

=head1 OPTIONS

=over 8

=item B<--spaces>

	optional. Set the number of spaces to use per tab stop.
	default 4

=item B<--maxlen>

	optional. Set the desired maximum line length.  If set, will show a breakdown of how many lines are longer than that.
	default N/A

=item B<--version>

	Prints the program version and exit.

=item B<--help> or B<-?>

	Print a brief help message and exit.

=item B<--man>

	Print the full help message and exit.

=back

=head1 DESCRIPTION

	This program will read the given input file(s) and show you lines
	which have inconsistent tabs and spaces.

=head1 SEE ALSO

	fix-spaces.sh, fix-tabs.sh

=head1 EXAMPLES

	ls-tabs.pl --spaces=3 hello.c

	list which files have some spacing problems
	for file in *.pl *.sh; do ls-tabs.pl $file > /dev/null || echo $file; done > mismatched.lst

=cut

use strict;
use warnings;

use English qw(-no_match_vars);
use Getopt::ArgvFile defult => 1;    # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;

#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			spaces  => 4,    # default number of spaces per tab stop
			maxlen  => 0,    # maximum desired line length if non-zero
			$STDIO  => 0,    # indicates standard in/out as - on command line
			debug   => 0,
			man     => 0,    # show full help page
		},
		raFile => [],
	},
	rhGetopt => {
		result   => undef,
		raErrors => [],
		raConfig => [
			"bundling",        # bundle single char options ie ps -aux
			"auto_version",    # supplies --version option
			"auto_help",       # supplies --help -? options to show usage in POD SYNOPSIS

##			"debug",           # debug the argument processing
		],
		raOpts => [
			"spaces|s:i",    # option sets the number of spaces per tab
			"maxlen|s:i",    # option sets the desired maximum line length
			"debug|d+",      # incremental keep specifying to increase
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName       => '<STDIN>',    # name of file
	prefix_tabs    => 0,
	prefix_doc     => 0,
	prefix_spaces  => 0,
	uneven_spacing => 0,
	code => 0,
	lines_seen => 0,
	line_lengths   => {},
	total_lengths  => 0,
	max_length     => 0,
);

sub pad
{
	my ($value, $size, $pad) = @ARG;
	$pad = $pad || ' ';
	return $value . ($pad x ($size - length($value)));
}

# Return the value of a command line option
sub opt
{
	my ($opt) = @ARG;
	return defined($opt) ?
		$Var{'rhArg'}{'rhOpt'}{$opt} :
		$Var{'rhArg'}{'rhOpt'};
}

sub hasOpt
{
	my ($opt) = @ARG;
	return exists( $Var{'rhArg'}{'rhOpt'}{$opt} );
}

sub setOpt
{
	my ( $opt, $value ) = @ARG;
	return $Var{'rhArg'}{'rhOpt'}{$opt} = $value;
}

sub arg
{
	my ($arg) = @ARG;
	return defined($arg) ?
		$Var{'rhArg'}{$arg} :
		$Var{'rhArg'};
}

sub setArg
{
	my ( $arg, $value ) = @ARG;
	return $Var{'rhArg'}{$arg} = $value;
}

getOptions();

sub main
{
	my ($raFiles) = @ARG;
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "main() rhOpt: " . Dumper( opt() ) .
		"\nraFiles: " . Dumper($raFiles) .
		"\nuse_stdio: @{[opt($STDIO)]}\n", 2 );

	if ( opt($STDIO) )
	{
		processStdio();
	}
	processFiles( $raFiles ) if scalar(@$raFiles);
	summary();
}

sub summary
{
	print "=====\n$Var{'lines_seen'} lines read\n";
	print "$Var{'prefix_spaces'} lines with prefix spacing\n";
	print "$Var{'prefix_doc'} lines with prefix space star for \@doc documentation\n";
	print "$Var{'prefix_tabs'} lines with prefix tabs\n";
	if ($Var{'uneven_spacing'})
	{
		print "spacing which mismatches tab depth (spaces=@{[opt('spaces')]}) found.\n";
		$Var{'code'} = 2;
	}
	if ($Var{'prefix_tabs'} && $Var{'prefix_spaces'})
	{
		print "mixed tabs and spaces found.\n";
		$Var{'code'} = 1;
	}

	print "spacing ok for tab stop @{[opt('spaces')]}\n" if $Var{'code'} == 0;
	if ($Var{'lines_seen'})
	{
		my $average_line = sprintf("%.1f", $Var{'total_lengths'} / $Var{'lines_seen'});
		print "$Var{'max_length'} characters in longest line.\n";
		print "$average_line characters per line on average.\n";

		my $MAX_LENGTH = opt('maxlen');
		my $MAX_COLS = $ENV{'COLUMNS'} || 79;
		if ($MAX_LENGTH && $Var{'max_length'} > $MAX_LENGTH)
		{
			debug("Line Lengths: " . Dumper($Var{'line_lengths'}), 2);
			debug("avail cols: $ENV{'COLUMNS'}", 2);
			print "Lines $MAX_LENGTH characters or longer:\n";
			my $max_count = 0;
			my $min_count;
			for my $length ($MAX_LENGTH .. $Var{'max_length'})
			{
				my $count = $Var{'line_lengths'}{$length};
				if ($count)
				{
					$max_count = $count if $count > $max_count;
					$min_count = $count unless $min_count;
					$min_count = $count if $count < $min_count;
				}
			}
			my $padding = length($Var{'max_length'}) + length($max_count) + 3;
			my $cols = $MAX_COLS - $padding;
			my $dot_rate = ($cols - 1.0)/($max_count - $min_count);
			debug("counts: $min_count to $max_count over $cols columns $padding padsize\n", 2);
			for my $length ($MAX_LENGTH .. $Var{'max_length'})
			{
				my $count = $Var{'line_lengths'}{$length};
				if ($count)
				{
					my $num = pad("$length: $count", $padding);
					my $bar_length = $cols * ($max_count - $min_count);
					my $dots = 1 + $dot_rate * ($count - $min_count);
					my $bar = '*' x $dots;
					print "$num$bar\n";
				}
			}
		}
	}
	exit($Var{'code'});
}

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
}

sub processStdio
{
	my $print = 0;
	debug("processStdio()\n");
	$Var{fileName} = "<STDIN>";
	while ( my $line = <STDIN> )
	{
		( $line, $print ) = doLine( $line, $print );
		print $line if $print;
	}
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processFile( $fileName );
	}
}

sub processFile
{
	my ($fileName) = @ARG;
	debug("processFile($fileName)\n");

	$Var{fileName} = $fileName;
	my $print = 0;
	my $fh;
	open( $fh, "<", $fileName );
	while ( my $line = <$fh> )
	{
		( $line, $print ) = doLine( $line, $print );
		print $line if $print;
	}
	close($fh);
}

sub show_line
{
	my ($line) = @ARG;
	$line =~ s{
		\A ([\ \t]+) (\n|\S|\z)
	}{
		mark_spacing($1) . $2;
	}xmsge;
	return "$Var{'lines_seen'} $line";
}

sub mark_spacing
{
	# mark spaces '.' tabs 'T' and a tab's worth of spaces as '|..|'
	my ($prefix) = @ARG;
	my $TAB_STOP = opt('spaces');
	debug("TAB_STOP: [$TAB_STOP]", 2);
	$prefix =~ s{ \ {$TAB_STOP} }{ '|' . ('.' x ($TAB_STOP - 2)) . '|' }xmsge;
	$prefix =~ tr[ \t][.T];
	$Var{'uneven_spacing'}++ if ($prefix =~ m{\.\z}xms);
	debug("prefix: $prefix", 2);
	return $prefix;
}

sub doLine
{
	my ($line, $print) = @ARG;

	my $length = length($line);
	++$Var{'lines_seen'};
	$Var{'line_lengths'}{$length}++;
	$Var{'total_lengths'} += $length;
	$Var{'max_length'} = $length if $length > $Var{'max_length'};
	# ignore lines with no lead spacing
	$print = 0;
	debug("$Var{'lines_seen'}: $line");
	return ($line, $print) if ($line =~ m{\A \S}xms);
	debug("past gate1, has some lead space");
	return ($line, $print) if ($line =~ m{\A (\n|\z)}xms);
	debug("past gate2, not an empty line");

	# ignore lines with tabs only, but count them
	if ($line =~ m{\A \t+ (\n|\S|\z)}xms)
	{
		$Var{'prefix_tabs'}++;
		return ($line, $print);
	}
	debug("past gate3, not lead tabs only");

	# ignore lines with tabs a single space and a star only, but count them (@doc formatted)
	if ($line =~ m{\A \t* \  \* (/|\ |\n|\z)}xms)
	{
		$Var{'prefix_doc'}++;
		return ($line, $print);
	}
	$Var{'prefix_spaces'}++;
	# handle lines with lead space only
	if ($line =~ m{\A \ + (\S|\z)}xms)
	{
		debug("lead space only");
		$line = show_line($line);
		$print = 1;
	}
	else
	{
		debug("mixed spaces and tabs");
		# handle lines with mixed spaces and tabs
		$Var{'prefix_tabs'}++;
		$line = show_line($line);
		$print = 1;
	}
	return ($line, $print);
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array

	if ( scalar(@$raErrors) )
	{
		usage( join( "\n", @$raErrors ) );
	}
}

sub checkMandatoryOptions
{
	my ( $raErrors, $raMandatory ) = @ARG;

	$raMandatory = $raMandatory || [];
	foreach my $option ( @{ $Var{rhGetopt}{raOpts} } )
	{
		# Getopt option has = sign for mandatory options
		my $optName = undef;
		$optName = $1 if $option =~ m{\A (\w+)}xms;
		if ( $option =~ m{\A (\w+) .* =}xms
			|| ( $optName && grep { $ARG eq $optName } @{$raMandatory} ) )
		{
			my $error = 0;

			# Work out what type of parameter it might be
			my $type = "value";
			$type = 'number value'                 if $option =~ m{=f}xms;
			$type = 'integer value'                if $option =~ m{=i}xms;
			$type = 'incremental value'            if $option =~ m{\+}xms;
			$type = 'negatable value'              if $option =~ m{\!}xms;
			$type = 'decimal/oct/hex/binary value' if $option =~ m{=o}xms;
			$type = 'string value'                 if $option =~ m{=s}xms;
			$type =~ s{value}{multi-value}xms    if $option =~ m{\@}xms;
			$type =~ s{value}{key/value pair}xms if $option =~ m{\%}xms;

			if ( hasOpt($optName) )
			{
				my $opt = opt($optName);
				my $ref = ref($opt);
				if ( 'ARRAY' eq $ref && 0 == scalar(@$opt) )
				{
					$error = 1;

					# type might not be configured but we know it now
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ( 'HASH' eq $ref && 0 == scalar( keys(%$opt) ) )
				{
					$error = 1;

					# type might not be configured but we know it now
					$type =~ s{value}{key/value pair}xms unless $type =~ m{key/value}xms;
				}
			}
			else
			{
				$error = 1;
			}
			push( @$raErrors, "--$optName $type is a mandatory parameter." ) if $error;
		}
	}
	return $raErrors;
}

# Perform command line option processing and call main function.
sub getOptions
{
	$Var{rhGetopt}{roParser}->configure( @{ $Var{rhGetopt}{raConfig} } );
	$Var{rhGetopt}{result} = $Var{rhGetopt}{roParser}->getoptions( opt(), @{ $Var{rhGetopt}{raOpts} } );
	if ( $Var{rhGetopt}{result} )
	{
		manual() if opt('man');
		setArg( 'raFile', \@ARGV );

		# set stdio option if no file names provided
		setOpt( $STDIO, 1 ) unless scalar( @{ arg('raFile') } );
		checkOptions( $Var{rhGetopt}{raErrors}, arg('raFile') );
		setup();
		main( arg('raFile'), opt($STDIO) );
	}
	else
	{
		# Here if unknown option provided
		usage();
	}
}

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

sub warning
{
	my ($warning) = @ARG;
	warn( "WARN: " . tab($warning) . "\n" );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	print tab($msg) . "\n" if ( opt('debug') >= $level );
}

sub usage
{
	my ($msg) = @ARG;
	my %Opts = (
		-exitval => 1,
		-verbose => 1,
	);
	$Opts{-msg} = $msg if $msg;
	pod2usage(%Opts);
}

sub manual
{
	pod2usage(
		-exitval => 0,
		-verbose => 2,
	);
}

__END__
