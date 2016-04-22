#!/usr/bin/env perl

=head1 NAME

pretty-elements.pl - Format some HTML elements one attribute per line.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

pretty-elements.pl [options] [@options-file ...] [file ...]

	Options:
		--edit           edit the files in place
		--warn-files     turn on display of filename for every warning
		--version        display program version
		--help -?        brief help message
		--man            full help message

=head1 OPTIONS

=over 8

=item B<--edit> or B<--noedit>

	Causes HTML elements to be edited in place in the input files.

=item B<--warn-files> or B<--nowarn-files>

	Causes the file name to be shown for all warning messages.
	Normally it only prints the file name for the first warning in a
	given file.

=item B<--version>

	Prints the program version and exit.

=item B<--help> or B<-?>

	Print a brief help message and exit.

=item B<--man>

	Print the full help message and exit.

=back

=head1 DESCRIPTION

	This program will read the given input file(s) and format some
	of the HTML elements with one attribute per line. Also puts some
	attributes into specific order for consistency i.e. id class name.

	It does a check on id/name attributes and gives warnings about
	duplicate id's and mismatches in id/name for form input fields.

	It has some support for Template::Toolkit and tries to work around
	attributes which are included within [% IF %] blocks.

=head1 EXAMPLES

	pretty-elements.pl views/*.tt

	./pretty-elements.pl tests/pretty-elements/sample-html-elements.txt
	./pretty-elements.pl tests/pretty-elements/sample-html-elements.txt 2>&1 | less

	find some types of tags which might have lots of attributes

	perl -ne 'sub BEGIN { $/ = undef; } s{([\ \t]*<(input|textarea|select|option|button|div|iframe|form|dl|a) \s+ [^>]+ >)}{print qq{$1\n}}xmsge; ' views/*.tt | less

	find anything and print by length of the tag

	perl -ne 'sub BEGIN { $/ = undef; } s{(<[a-zA-Z] [^>]* >)}{my $tag = $1; my $otag = $1; $tag =~ s{(\s)\s*}{\ }xmsg; print qq{@{[length($otag)]} $tag\n}}xmsge; ' views/*.tt | sort -n -r | less

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

use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use autodie qw(cp);

our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO  => 0,    # indicates standard in/out as - on command line
			verbose => 1,    # default value for verbose
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
			"edit|e!",    # flag --edit or --noedit
			"warn-files|w!", # flag to show filename for every warning
			"debug|d+",      # incremental keep specifying to increase
			"verbose|v!",    # flag --verbose or --noverbose
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	# Some constants for the program
	raAttrOrder => [qw(id name type tabindex class style value method title alt data-bind action target href)],
	raElements => [qw(input textarea select option button div iframe form dl a)],
	q => chr(34).chr(39),  # both types of quotes
	sol => '[\ \t]*',      # start of line whitespace
	eol => '[\ \t]*\n',    # whitespace and end of line
	empty => '',
	# handle Template Toolkit
	# [% IF tab_selected == 'view_campaign_heatmap' %]class="selected"[% END %] and similar
	reTTBlock => qr{ ( \[ \% .? \s* (?:IF|UNLESS) .+?  END .? \% \] ) }xms,
	# handle greater than within a Template Toolkit block with a temporary substitution
	# [% IF current_targeting.from_age AND current_targeting.from_age > 0 %][% current_targeting.from_age %][% END %]
	reTTGreater => qr{ ( \[ \% .? \s* (?:IF|UNLESS) [^%]+? ) > ( .+? \% \] ) }xms,
	tt_greater => '__HACK_FOR_GREATER_THAN__',
	reAttribTrue => qr{ \b ([\w|-]+) \b }xms,

	# Some vars for the program
	fileName   => '<STDIN>',    # name of file
	rhIDs => {},
	rhWarnFiles => {},
);
$Var{elements} = join('|', @{$Var{raElements}});
$Var{reElement} = qr{ ( $Var{sol} < ($Var{elements}) \s+ (.+?) (/?>) ) }xms;
$Var{reAttrib} = qr{ \b ([\w|-]+) \s* = ( \d+ | ([$Var{q}]) (.*?) \3 ) }xms;

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
		processEntireStdio();
	}
	if (scalar(@$raFiles))
	{
		if (hasOpt('edit'))
		{
			editFilesInPlace( $raFiles, ".bak" );
		}
		else
		{
			processFiles( $raFiles );
		}
	}
}

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');

	debug("reElement: $Var{reElement}");
	debug("reAttrib: $Var{reAttrib}");
	debug("reAttribTrue: $Var{reAttribTrue}");
	debug("reTTBlock: $Var{reTTBlock}");
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
}

sub editFilesInPlace
{
	my ($raFiles, $suffix, $rhOpt) = @ARG;
	debug("editFilesInPlace()\n");
	foreach my $fileName (@$raFiles)
	{
		editFileInPlace($fileName, $suffix, $rhOpt);
	}
}

sub editFileInPlace
{
	my ( $fileName, $suffix ) = @ARG;
	$Var{fileName} = $fileName;
	my $fileNameBackup = "$fileName$suffix";
	debug("editFileInPlace($fileName) backup to $fileNameBackup");

	unless ($fileName eq $fileNameBackup)
	{
		cp( $fileName, $fileNameBackup );
	}
	edit_file { doReplacement( \$ARG ) } $fileName;
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );
	doReplacement( $rContent );
	print $$rContent;
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processEntireFile( $fileName );
	}
}

sub processEntireFile
{
	my ($fileName) = @ARG;
	debug("processEntireFile($fileName)\n");

	# example slurp in the file and show something
	$Var{fileName} = $fileName;
	my $rContent = read_file( $fileName, scalar_ref => 1 );
	doReplacement( $rContent );
	print $$rContent;
}

# Get the attributes from an element.
# Store any Template Toolkit IF blocks separately (in key __TT_BLOCKS__)
# If there was anything unparseable leftover it goes into __LEFTOVERS__ key
# and generates a warning.
sub get_attributes
{
	my ($attributes, $all) = @ARG;
	my %Attribs = ('__TT_BLOCKS__', []);

	# First pull out any Template toolkit conditions
	$attributes =~ s{ $Var{reTTBlock} }{
		my ($condition) = ($1);
		# unreplace the greater than sign marker now
		push(@{$Attribs{'__TT_BLOCKS__'}}, unhack($condition));
		$Var{'empty'};
	}xmsge;

	$attributes =~ s{ $Var{'reAttrib'} }{
		my ($attr, $val) = ($1, $2);
		$val = qq{"$val"} unless $val =~ m{\A[$Var{'q'}]}xms;
		$Attribs{$attr} = qq{$val};
		$Var{'empty'};
	}xmsge;

	$attributes =~ s{ $Var{'reAttribTrue'} }{
		my ($attr) = ($1);
		$Attribs{$attr} = qq{__TRUE__};
		$Var{'empty'};
	}xmsge;

	$attributes =~ s{\A \s+ \z}{}xms;
	if ($attributes ne $Var{'empty'})
	{
		warning($Var{'fileName'}, "leftovers in element: [$attributes]\n   unhack($all)");
		$Attribs{'__LEFTOVERS__'} = $attributes;
	}
	return \%Attribs;
}

# Format an attribute of an element
sub format_attr
{
	my ($attr, $value) = @ARG;
	if ($value eq '__TRUE__')
	{
		$value = $Var{'empty'};
	}
	else
	{
		$value = qq{=$value};
	}
	return qq{$attr$value};
}

# Format an element with some attributes in specific order
# and each attribute on its own line
sub format_element
{
	my ($all, $element, $rhAttribs, $ending) = @ARG;
	my @Attribs = ();

	# capture the initial indentation of the element
	$all =~ m{\A (\s*)}xms;
	my $leadin = $1 || "";

	# handle the template toolkit blocks
	my @TTBlocks = @{$rhAttribs->{'__TT_BLOCKS__'}};
	delete($rhAttribs->{'__TT_BLOCKS__'});

	foreach my $attr (@{$Var{'raAttrOrder'}})
	{
		push(@Attribs, format_attr($attr, $rhAttribs->{$attr})) if exists($rhAttribs->{$attr});
		delete($rhAttribs->{$attr});
	}
	foreach my $attr (sort(keys(%$rhAttribs)))
	{
		push(@Attribs, format_attr($attr, $rhAttribs->{$attr}));
	}

	my $attribs = join("\n$leadin\t", @Attribs, @TTBlocks, $ending);
	if (scalar(@Attribs) + scalar(@TTBlocks) == 1)
	{
		$attribs = join("", @Attribs, @TTBlocks, $ending);
	}

	$attribs = " " . $attribs if length($attribs);
	my $formatted = qq{$leadin<$element$attribs};
	return opt('debug') ? "FORMATTED:\n$formatted" : $formatted;
}

# Trim leading space from string
sub trim
{
	my ($string) = @ARG;
	$string =~ s{ \A \s+ }{}xms;
	return $string;
}

# Unhack the greater than signs
sub unhack
{
	my ($string) = @ARG;
	$string =~ s[ $Var{'tt_greater'} ][>]xmsg;
	return $string;
}

# Update register of all id values seen to locate duplicates
sub register_id
{
	my ($all, $id, $rhAttribs) = @ARG;
	$rhAttribs->{'id'} = $id;
	if (exists($Var{'rhIDs'}{$id}))
	{
		warning($Var{'fileName'}, "duplicate id seen [$id]\n   [@{[unhack(trim($all))]}]\n   [@{[trim($Var{'rhIDs'}{$id}[0])]}]\n");
	}
	push(@{$Var{'rhIDs'}{$id}}, unhack($all));
}

# If id/name missing for an input, add it
# print a warning for mismatched id/name (unless a radio button)
sub handle_id_name
{
	my ($all, $element, $rhAttribs) = @ARG;
	if ($element eq "input")
	{
		my $mismatch = 0;
		if (exists($rhAttribs->{'id'}))
		{
			register_id($all, $rhAttribs->{'id'}, $rhAttribs);
			if (!exists($rhAttribs->{'name'}))
			{
				$rhAttribs->{'name'} = $rhAttribs->{'id'};
			}
			if ($rhAttribs->{'id'} ne ($rhAttribs->{'name'} || ""))
			{
				$mismatch = 1;
			}
		}
		elsif (exists($rhAttribs->{'name'}))
		{
			# No need to set the ID for hidden fields
			register_id($all, $rhAttribs->{'name'}, $rhAttribs)
				unless exists($rhAttribs->{'type'}) && $rhAttribs->{'type'} eq '"hidden"';
		}
		if (exists($rhAttribs->{'type'}) && $rhAttribs->{'type'} eq '"radio"')
		{
			# radio boxes must have different id/name
			$mismatch = 0;
		}
		if ($mismatch)
		{
			warning($Var{'fileName'}, "id/name mismatch in element: [$element]\n   [$all]");
		}
	}
}

# Handle an element that has been found. Extracts attributes
# and checks for id/name problems, then returns the formatted
# element for output.
sub handle_element
{
	my ($all, $element, $attribs, $ending) = @ARG;
	my $rhAttribs = get_attributes($attribs, $all);

	handle_id_name($all, $element, $rhAttribs);

	debug(qq{\n[$all]\n   [$element] [$ending] [$attribs]});
	debug(Dumper($rhAttribs), 2);
	return format_element($all, $element, $rhAttribs, $ending);
}

sub doReplacement
{
	my ($rContent) = @ARG;

	# Hack to handle a greater than within a template toolkit IF block,
	# replace it with some obscure text and unreplace it later when formatting.
	$$rContent =~ s{ $Var{'reTTGreater'} }{$1$Var{'tt_greater'}$2}xmsg;
	$$rContent =~ s{ $Var{'reElement'} }{
		my ($all, $element, $attribs, $ending) = ($1, $2, $3, $4);
		handle_element($all, $element, $attribs, $ending);
	}xmsge;
	$$rContent =~ s{ $Var{'tt_greater'} }{>}xmsg;

	return $rContent;
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
	my ($fileName, $warning) = @ARG;
	unless (exists($Var{'rhWarnFiles'}{$fileName})
		&& !opt('warn-files'))
	{
		$warning = "$fileName: $warning";
	}
	$Var{'rhWarnFiles'}{$fileName}++;
	warn( "WARN: " . tab($warning) );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	print tab($msg . "\n") if ( opt('debug') >= $level );
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
