#!/usr/bin/env perl

=head1 NAME

filter-css-colors.pl - Find all CSS color declarations in files with option to replace then with standard color name or Less/Sass constants.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

filter-css-colors.pl [options] [@options-file ...] [file ...]

 Options:
	--color-only     negatable. only show the color values, not the entire line.
	--reverse        negatable. show all lines not matching a CSS color declaration.
	--remap          negatable. remap all colors to names or constants in place where possible.
	--names          negatable. convert colors to standard names where possible.
	--canonical      negatable. convert colors to canonical form i.e. #fff -> #ffffff
	--shorten        negatable. convert colors to short form i.e. #ffffff -> #fff
	--rgb            negatable. convert colors to rgb() form.
	--hash           negatable. convert rgb/hsl colors to #color form.
	--valid-only     negatable. do not perform remappings which are invalid CSS.
	--show-const     negatable. show the table of defined constants.
	--const-type     specify what type of constants are being used (for less or sass.)
	--const          multiple. define a custom constant value.
	--const-file     multiple. specify a Less, Sass or CSS file to parse for color constants.
	--const-list     list all possible constant names for a given color substitution in a comment.
	--const-pull     pull color values into new named constants and output to file or standard output.
	--inplace        specify to modify files in place creating a backup first.
	--foreground     [not implemented] specify a color value to use for all foreground colors.
	--background     [not implemented] specify a color value to use for all background colors.
	--echo           negatable. display original line when performing replacements.
	--version        display program version and exit.
	--debug          incremental. display debugging info.
	--tests          run the unit tests.
	--help -?        brief help message and exit.
	--man            full help message and exit.

=head1 OPTIONS

=over 8

=item B<--color-only> or B<--nocolor-only>

 Only display the CSS color values used. Useful to identify all unique colors used.

=item B<--reverse> or B<--noreverse>

 Only display lines that do not contain CSS color declarations.

=item B<--remap> or B<--noremap>

 Remap colors to constants, canonical values and/or names in place where possible. May not produce valid CSS as for example rgba(0,0,0,0.5) becomes rgba(black,0.5)

 You should specify --names or --canonical as well to have any effect.

=item B<--names> or B<--nonames>

 Show colors as standard names where possible. i.e. #fff becomes white.
 Implies --canonical as well.
 Implies --hash as well.
 Implies --remap as well.

=item B<--canonical> or B<--nocanonical>

 Show colors in canonical form i.e. #fff becomes '#ffffff'.
 Implies --remap as well.

=item B<--shorten> or B<--noshorten>

 Show colors in short form i.e. #ffffff becomes '#fff'.
 Implies --remap as well.

=item B<--hash>  or B<--nohash>

 Show rgb/hsl colors as #color i.e. rgb(255, 255, 255) becomes #fff or #ffffff.
 Cannot use --rgb with --hash.

=item B<--rgb>  or B<--norgb>

 Show colors in rgb() form i.e. #fff becomes rgb(255, 255, 255).
 Implies --canonical as well. Cannot use --names or --hash with --rgb.

=item B<--show-const>  or B<--noshow-const>

 Show a table of the defined constants.

=item B<--const-type=s>

 Define what type of constants are being used. Default is Less (@)
 You can specify less, sass or a character to use as a prefix.

 --const-type=less    @button-background:  #fff; // different from $button_background
 --const-type=sass    $button-background:  #fff; // equivalent to $button_background

=item B<--const=name=value>

 Define a constant color value. You can omit the prefix character when defining a value.

 --const=button-background=#fff // default Less would be @button-background
 --const=$button-background=#fff

=item B<--const-file=less-sass-css-filename>

 Specify files to parse for color constant definitions. You must specify --const-type if you are parsing CSS files for constants. The format of a color constant definition is:

 less:  @name-of-constant: #color;
 sass:  $name-of-constant: #color; // equivalent to $name_of_constant
 css:   .name-of-constant { color: #color; }

=item B<--const-list> or B<--noconst-list>

 When a color value matches to many defined constants, the list of possibles is shown in a comment after the color substitution.

 i.e. color: @background /* @background, @panel-background */;

=item B<--const-pull=-|filename>

 If there is no constant defined for a color value it will define one for you automatically. Specify Less or Sass defined constants using --const-type. You must specify --remap for this to have effect. After scanning all files these newly defined constants will be appended to the named file or standard output (-)

=item B<--valid-only> or B<--novalid-only>

 Do not perform name remappings which are invalid css3
 i.e. rgba(0,0,0,0.3) will not become rgba(black,0.3)

=item B<--inplace=.suffix>

 Modify files in place and create a backup file first. This acts like perl's -i.suffix option. It's probably a good idea to use --valid-only and not --echo when doing this.

=item B<--foreground=color> or B<--fg=color>

 Specify a color value to use to replace all foreground colors with. Cannot work with --color-only.

=item B<--background=color> or B<--bg=color>

 Specify a color value to use to replace all background colors with. Cannot work with --color-only.

=item B<--echo> or B<--noecho>

 When in a --remap mode, display the original line as well.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 Template for a perl script with the usual bells and whistles. Supports long option parsing and perldoc perl.pl to show pod.

 B<This program> will read the given input file(s) and do something useful with the contents thereof.

=head1 SEE ALSO

 CSS Color specs L<http://www.w3.org/TR/css3-color/>

=head1 EXAMPLES

 Find all unique colors used in all CSS files somewhere

 filter-css-colors.pl --color-only --names `find /cygdrive/d/d/s/github -name '*.css'` | sort | uniq

=head1 TODO

--foreground=xxxx substitute a color for all foreground colors
--background=xxxx you get color: #fff /* original color */;
--undo undo a foreground/background change

--closest mark hard coded colors with the closest named color
--constants  automatically define color constants from hard coded values
    fg_1 bg_ etc
--use-var=name  when multiple vars are possible for a color, use the named one

parse .less color constants
 perl -MData::Dumper -ne 'if (m{\A \s* ( \@ [\-\w]+ ) \s* : \s* ( \#[0-9a-f]+ ) \s* ;}xms) { push(@{$var{$2}}, $1) }; END { print Dumper(\%var)} '  `find /home/bcowgill/projects/files-ui/lib/bower_components/ -name variables.less`

for computed colors write a CSS rule to show what the computed value is
cat $VARS | perl -pne 'if (m{\@ ([\-\w]+) \s* : .* (fadein|darken|lighten)}xms) { $_ = qq{\n$_.$1-defined { color: \@$1; }\n} };' | less
egrep 'lighten|darken' $VARS | perl -pne 'if (m{\@ ([\-\w]+) \s* :}xms) { $_ .= qq{.$1 { color: \@$1; }\n} };'

cat $VARS | perl -pne 'if (m{\@ ([\-\w]+) \s* : .* (darken|lighten)}xms) { $_ = qq{\n$_.$1 { color: \@$1; }\n} };' | less > my.less
lessc my.less > my.css

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
use autodie qw(open cp);

our $TEST_CASES = 380;
our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";
our $HASH    = '\#';

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			'valid-only' => 0,
			'const-type' => '@', # assumes using less CSS compiler
			'const-rigid' => 1,  # rigid constant considers - and _ as different in names
			'const-list' => 0,
			$STDIO  => 0,        # indicates standard in/out as - on command line
			debug   => 0,
			tests   => 0,
			man     => 0,        # show full help page
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
			"color-only!",
			"reverse!",
			"remap!",
			"names!",
			"canonical!",
			"shorten!",
			"rgb!",
			"hash!",
			"valid-only!",
			"show-const!",
			"const-type:s",
			'const:s%',
			'const-file:s@',
			'const-list!',
			'const-pull:s',
			"inplace|i:s",
			"foreground|fg:s",
			"background|bg:s",
			"echo!",
			"debug|d+",      # incremental keep specifying to increase
			"tests!",        # run the unit tests
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	'raColorNames' => ['transparent'],
	'constantContext' => '',    # option or line where constant is defined
	'rhColorNamesMap' => {},
	'rhConstantsMap' => {},      # @const => #color
	'rhUndefinedConstantsMap' => {}, # @const1 => @const2
	'raAutoConstants' => [],
	'rhColorConstantsMap' => {}, # #color => [@const, ... ]
	'regex' => {
		'data'        => qr{ \A \s* (\w+) \s+ ( $HASH [0-9a-f]{6} ) \s+ ( \d+,\d+,\d+ ) }xmsi,
		'cssConst'    => qr{ ( \. ([-\w]+) -defined \s* \{ \s* color \s* : \s* ([^;]+) \s* ; \s* \}) }xms,
		'constDef'    => qr{ ( [\@\$] ([-\w]+) \s* : \s* ([^;]+) \s* ; ) }xms,
		'names'       => '', # populated in setup()
		'line'        => '', # populated in setup()
		'hashColor'   => qr{ $HASH ([0-9a-f]{3,6}) \b }xmsi,
		'shortColor'  => qr{ $HASH ([0-9a-f]{3}) \b }xmsi,
		'canShortenColor' => qr{ $HASH ([0-9a-f])\1 ([0-9a-f])\2 ([0-9a-f])\3 \b }xmsi,
		'bytesColor'  => qr{ $HASH ([0-9a-f]{2}) ([0-9a-f]{2}) ([0-9a-f]{2}) \b }xmsi,
		'transparent' => qr{ (rgb|hsl) a \( [^\)]+? , \s* [0\.]+ \s* \) }xmsi,
		'opaque'      => qr{ (rgb|hsl) a ( \( [^\)]+ ) , \s* 1(\.0*)? \s* \) }xmsi,
		'rgbCanon'    => qr{ rgb     \( \s* ( \d+ \%?) \s* , \s* (\d+ \%?) \s* , \s* (\d+ \%?)    \s* \) }xmsi,
		'rgba'        => qr{ \A rgba \( \s* ( \d+ \%?  \s* , \s*  \d+ \%?  \s* , \s*  \d+ \%? ) ( \s* , \s* [^\)]+ ) \) }xms,
		'hslToRgb'    => qr{ hsl(a?) \( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% \s* }xms,
		'rgbaCanon'   => qr{ rgb(a?) \( \s* (\d+ \%?) \s* , \s* (\d+ \%?) \s* , \s* (\d+ \%?) \s* }xmsi,
		'isRgb'       => qr{ \A rgb a? \( }xmsi,
		'isRgbIsh'    => qr{ \A (rgb|hsl) a? \( }xmsi,
		'hslInvalid'  => qr{ \A hsla \( \s* (\w+|\#[0-9a-f]{3,6}) }xmsi,
		'hsla'        => qr{ \A hsla \( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% ( \s* , \s* [^\)]+ ) \) }xms,
	},
);

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
	debug( "Var: " . Dumper( \%Var ), 5 );
	debug( "main() rhOpt: " . Dumper( opt() ) .
		"\nraFiles: " . Dumper($raFiles) .
		"\nuse_stdio: @{[opt($STDIO)]}\n", 2 );

	if ( opt($STDIO) )
	{
		processEntireStdio();
	}

	processFiles($raFiles) if scalar(@$raFiles);
	summary();
}

sub setup
{
	debug("setup()");
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');

	readColorNameData();
	eval
	{
		constructConstantsTable();
		debug("const files: " . Dumper(opt('const-file')), 2);
		processConstantFiles() if (scalar(opt('const-file')));
		resolveConstants();
	};
	if ($EVAL_ERROR)
	{
		die "Error $Var{constantContext}: $EVAL_ERROR\n";
	}
	showConstantsTable() if opt('show-const');
}

sub summary
{
	showAutoContants();
}

sub showAutoContants
{
	my $out = opt('const-pull');
	if ($out)
	{
		my $fh = *STDOUT;
		open($fh, '>>', $out) unless ($out eq '-');
		debug("summary: raAutoConstants" . Dumper($Var{'raAutoConstants'}), 3);
		debug("summary: rhColorConstantsMap" . Dumper($Var{'rhColorConstantsMap'}), 3);
		debug("summary: rhConstantsMap" . Dumper($Var{'rhConstantsMap'}), 3);
		foreach my $color (@{$Var{'raAutoConstants'}})
		{
			my $const = $Var{'rhColorConstantsMap'}{uniqueColor($color)}[0];
			my $rgb = rgb($color, 'force');
			print $fh "$const: $color; // $rgb\n";
		}
		close($fh) unless ($out eq '-');
	}
}

sub readColorNameData
{
	debug("readColorNameData()");
	# read from __DATA__ below to get names of hex color values
	while (my $line = <DATA>)
	{
		if ($line =~ m{ $Var{'regex'}{'data'} }xmsi)
		{
			my ($name, $color, $rgb) = ($1, $2, $3);

			$color = lc($color);
			$rgb = formatRgbIshColor($rgb);
			push(@{$Var{'raColorNames'}}, $name);
			$Var{'rhColorNamesMap'}{$color} = $name;
			$color = shorten($color, 'force');
			$Var{'rhColorNamesMap'}{$color} = $name;

			$Var{'rhColorNamesMap'}{"rgb($rgb)"} = $name;
			# TODO also add hsl version of color?
			$Var{'rhColorNamesMap'}{$rgb} = $name;
		}
	}
	debug("ColorNameMap " . Dumper($Var{'rhColorNamesMap'}), 5);
	my $colors = join('|', @{$Var{'raColorNames'}});
	debug("colors regex: $colors\n", 5);
	$Var{'regex'}{'names'} = qr{ (?<![-\w]) ($colors) (?![-\w]) }xmsi;
	$Var{'regex'}{'line'} = qr{
		( $HASH [0-9a-f]{3,6} \b | (rgb|hsl) a? \( [^\)]+ \) | (?<![-\w]) ($colors) (?![-\w]) )
	}xmsi;
}

sub constructConstantsTable
{
	debug("constructConstantsTable()\n");
	my ($prefix, $rhConstOptions);

	setOpt('const-type', '@') if (isUsingLess());
	if (isUsingSass())
	{
		setOpt('const-type', '$');
		setOpt('const-rigid', 0);
	}
	$prefix = opt('const-type');

	debug("Constants " . opt('const-type') . " rigid? " . opt('const-rigid') );
	debug("const options: " . Dumper(opt('const')), 2);

	$rhConstOptions = opt('const');
	foreach my $const (sort(keys(%{$rhConstOptions})))
	{
		my $value = $rhConstOptions->{$const};
		$Var{'constantContext'} = "in option --const=$const=$value";
		debug("const: $Var{'constantContext'}", 2);
		$const = "$prefix$const" unless isConst($const);
		checkConstName($const);
		$value || die "MUSTDO error constant $const has no assigned value";
		registerConstant($const, $value);
	}
	debug("constants: " . Dumper($Var{'rhConstantsMap'}), 2);
	debug("colors" . Dumper($Var{'rhColorConstantsMap'}), 2);
}

sub processConstantFiles
{
	debug("processConstantFiles()\n");
	my $raFiles = opt('const-file');
	foreach my $file (@$raFiles)
	{
		processConstantFile($file);
	}
}

sub processConstantFile
{
	my ($fileName) = @ARG;
	debug("processConstantFile($fileName)\n");
	my $prefix = opt('const-type');

	$Var{fileName} = $fileName;
	my $rContent = read_file($fileName, scalar_ref => 1);

	$$rContent =~ s{
		$Var{'regex'}{'cssConst'}
	}{
		my ($match, $const, $value) = ($1, $2, $3);
		registerConstantFromFile($prefix . $const, $value, $match) if isConstOrColor($value);
		$match;
	}xmsge;

	$$rContent =~ s{
		$Var{'regex'}{'constDef'}
	}{
		my ($match, $const, $value) = ($1, $2, $3);
		registerConstantFromFile($prefix . $const, $value, $match) if isConstOrColor($value);
		$match;
	}xmsge;
}

sub isUsingLess
{
	return opt('const-type') =~ m{\A [l\@]}xmsi;
}

sub isUsingSass
{
	return opt('const-type') =~ m{\A [s\$]}xmsi;
}

sub isConst
{
	my ($const) = @ARG;
	my $prefix = q{\\} . opt('const-type');
	my $regex = qr{\A $prefix}xms;
	debug("isConst($const) $regex " . $const =~ $regex, 4);
	return $const =~ $regex;
}

sub isConstOrColor
{
	my ($const) = @ARG;
	debug("isConstOrColor($const)", 4);
	return isConst($const) || isColor($const);
}

sub isColor
{
	my ($value) = @ARG;
	my $regex = qr{
		\A $Var{'regex'}{'line'} \z
	}xms;

	debug("isColor($value) $regex " . $value =~ $regex, 4);
	return $value =~ $regex;
}

sub isColorOkToConvertToConstant
{
	my ($value, $origValue, $match) = @ARG;
	my $quoted = quotemeta($origValue);
	my $regexContext = qr{
		: \s* $quoted \s* [;\}]
	}xms;
	my $regex = qr{
		\A (
			$Var{'regex'}{'hashColor'}
		) \z
	}xms;

	debug("isColorOkToConvertToConstant() quoted $quoted", 4);
	debug("isColorOkToConvertToConstant($match) $regexContext " . $match =~ $regexContext, 4);
	debug("isColorOkToConvertToConstant($value) $regex " . $value =~ $regex, 4);
	return ($value ne 'transparent') && ( $match =~ $regexContext || $value =~ $regex );
}

sub checkConstName
{
	my ($const) = @ARG;
	my $prefix = q{\\} . opt('const-type');
	$const =~ m{\A $prefix [-\w]+ \z}xms || die "MUSTDO constant name/expression not supported [$const]";
}

sub registerConstantFromFile
{
	my ($const, $value, $match) = @ARG;
	$match =~ s{\s\s+}{ }xmsg;
	$Var{'constantContext'} = "in file $Var{fileName} at line [$match]";
	eval
	{
		registerConstant($const, $value);
	};
	if ($EVAL_ERROR)
	{
		warning("Error $Var{constantContext}: $EVAL_ERROR\n");
		$EVAL_ERROR = undef;
	}
}

sub registerConstant
{
	my ($const, $value) = @ARG;

	debug("registerConstant($const, $value)", 3);
	$Var{'rhConstantsMap'}{$const} && die "MUSTDO error constant $const: $value already has a defined value: $Var{'rhConstantsMap'}{$const}";
	if (isConst($value))
	{
		checkConstName($value);
		if (isDefinedConst($value))
		{
			$value = getConstValue($value)
		}
		else
		{
			$Var{'rhUndefinedConstantsMap'}{$const} = $value;
			$const = undef;
		}
	}
	if ($const)
	{
		my $rgb;
		($value, $rgb) = getBothColorValues($value);
		$Var{'rhConstantsMap'}{$const} = $value;
		debug("registerConstant($const) 2 c=$value", 3);
		push( @{ $Var{'rhColorConstantsMap'}{$value} }, $const );
		if ($value ne $rgb)
		{
			debug("registerConstant($const) 3 r=$rgb", 3);
			push( @{ $Var{'rhColorConstantsMap'}{$rgb} }, $const );
		}
		return 1;
	}
	return 0;
}

sub resolveConstants
{
	my @consts = keys(%{$Var{'rhUndefinedConstantsMap'}});
	$Var{'constantContext'} = "after reading all constant files";
	debug("constants: " . Dumper($Var{'rhConstantsMap'}), 2);
	debug("unresolved: " . Dumper($Var{'rhUndefinedConstantsMap'}), 2);
	my $limit = 1000;
	while ($limit && scalar(@consts))
	{
		--$limit;
		foreach my $const (@consts)
		{
			if (registerConstant($const, $Var{'rhUndefinedConstantsMap'}{$const}))
			{
				delete($Var{'rhUndefinedConstantsMap'}{$const});
			}
		}
		@consts = keys(%{$Var{'rhUndefinedConstantsMap'}});
	}
	warning("MUSTDO unable to resolve some constant values") unless $limit;
}

sub isDefinedConst
{
	my ($const) = @ARG;

	if (opt('const-rigid'))
	{
		return exists($Var{'rhConstantsMap'}{$const});
	}
	else
	{
		die "MUSTDO not yet implemented for constants of type " . opt('const-type');
	}
}

sub getConstValue
{
	my ($const) = @ARG;

	if (opt('const-rigid'))
	{
		return $Var{'rhConstantsMap'}{$const};
	}
	else
	{
		die "MUSTDO not yet implemented for constants of type " . opt('const-type');
	}
}

sub showConstantsTable
{
	debug("showConstantsTable()\n");
	debug("constants: " . Dumper($Var{'rhConstantsMap'}), 2);
	debug("colors" . Dumper($Var{'rhColorConstantsMap'}), 2);

	print "// Color constant definitions:\n";
	foreach my $color (sort(keys(%{$Var{'rhColorConstantsMap'}})))
	{
		foreach my $const (sort(@{$Var{'rhColorConstantsMap'}{$color}}))
		{
			my $print = 1;
			if ($color !~ m{\A (rgb|hsl)}xms)
			{
				# if color is name or #color suppress print #color if rgb mode
				$print = 0 if opt('rgb') && $color =~ m{\A \#}xms;
			}
			else
			{
				# if color is rgba? or hsla? suppress print rgb if not rgb mode
				$print = 0 if !opt('rgb') && $color =~ m{\A rgb \(}xms;
			}
			print "$const: $color;\n" if $print;
		}
		print "\n";
	}
}

sub editFileInPlace
{
	my ( $fileName, $suffix ) = @ARG;
	$Var{fileName} = $fileName;
	my $fileNameBackup = "$fileName$suffix";
	debug("editFileInPlace($fileName) backup to $fileNameBackup\n");

	unless ($fileName eq $fileNameBackup)
	{
		cp( $fileName, $fileNameBackup );
	}
	edit_file_lines { $ARG = doReplaceLine($ARG) } $fileName;
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $raContent = read_file(\*STDIN, array_ref => 1);
	doReplacement( $raContent );
	print join("", @$raContent);
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		if ( opt('inplace') )
		{
			editFileInPlace($fileName, opt('inplace'));
		}
		else
		{
			processEntireFile( $fileName );
		}
	}
}

sub processEntireFile
{
	my ($fileName) = @ARG;
	debug("processEntireFile($fileName)\n");

	$Var{fileName} = $fileName;
	my $raContent = read_file($fileName, array_ref => 1);
	doReplacement( $raContent );
	print join("", @$raContent);
}

sub doReplacement
{
	my ( $raContent ) = @ARG;
	foreach my $line (@$raContent)
	{
		$line = doReplaceLine($line);
	}
	return $raContent;
}

sub doReplaceLine
{
	my ($line) = @ARG;
	debug("doReplaceLine($line)", 3);
	my $match = 0;
	my @Lines = ();
	# unfortunately the color name matching could match comments, or class/id names in the CSS
	# and can't check for a : before because rule could be split across two lines
	# maybe using negative lookbefore for # - . could handle the color names would also have
	# to strip comments first
	$match = ($line =~ $Var{'regex'}{'line'});
	$match = opt('reverse') ? !$match : $match;
	$match = 1 if opt('inplace');
	if ($match)
	{
		$line =~ s{ \A (\s*) }{}xms;
		my $preSpace = (opt('inplace') ? $1: '') || '';
		if (opt('color-only') && !opt('reverse'))
		{
			$line =~ tr[A-Z][a-z];
			$line =~ s{$Var{'regex'}{'line'}}{ push(@Lines, remap($1) . "\n"); "" }ge;
		}
		else
		{
			if (opt('echo'))
			{
				push(@Lines, "\nwas: $line     ");
			}
			push(@Lines, $preSpace . remap($line));
		}
	}
	debug("lines: " . Dumper(\@Lines));
	return join("", @Lines);
}

# remap color values in place, where possible
# this may not produce valid CSS output.
# for example rgba(0,0,0,0.5) can become rgba(black,0.5)
sub remap
{
	my ($line) = @ARG;
	if (opt('remap'))
	{
		debug("remap($line)", 3);
		$line =~ s{$Var{'regex'}{'line'}}{ substituteConstants($1, $line) }ge;
	}
	return $line;
}

sub substituteConstants
{
	my ($color, $line) = @ARG;

	my $origColor = $color;
	debug("substituteConstants($color, $line)", 3);
	$color = lookupConstant(renameColor($color));
	debug("substituteConstants() lookup $color", 3);
	if (opt('const-pull') && !isConst($color))
	{
		$color = defineAutoConstant($color, $origColor, $line);
		debug("substituteConstants() define $color", 3);
	}
	else
	{
		$color = renameColor($origColor);
		debug("substituteConstants() nodefine $origColor $color", 3);
	}

	debug("substituteConstants() out $color", 3);
	return $color;
}

# Given a color value see if there is a constant already defined
# for that color value. Returns the constant name or original
# color if none.
sub lookupConstant
{
	my ($color) = @ARG;
	my ($origColor, $rgb) = ($color);
	debug("lookupConstant($origColor)", 2);
	($color, $rgb) = getBothColorValues(uniqueColor($color));
	my $raConstants = $Var{'rhColorConstantsMap'}{$color} || $Var{'rhColorConstantsMap'}{$rgb};
	if ($raConstants)
	{
		$color = $raConstants->[0];
		if (opt('const-list') && (scalar(@$raConstants) > 1))
		{
			$color .= qq{ /* @{[join(', ', @$raConstants)]}*/};
		}
	}
	elsif ($color ne $origColor)
	{
		debug("lookupConstant() delta $color, $origColor", 3);
		$color = $origColor;
	}
	return $color;
}

# rename a color value based on command line options
sub renameColor
{
	my ($color) = @ARG;
	return names(rgb(hashColorStandard(toHashColor($color))));
}

sub defineAutoConstant
{
	my ($color, $origColor, $match) = @ARG;
	debug("defineAutoConstant($color, $origColor, $match)");

	my $const = $color;
	if (isColorOkToConvertToConstant($color, $origColor, $match))
	{
		$const = opt('const-type') . "autoConstant" . scalar(@{$Var{'raAutoConstants'}});
		$color = uniqueColor($color);
		push(@{$Var{'raAutoConstants'}}, $color);
		registerConstantFromFile($const, $color, $match);
	}
	debug("defineAutoConstant() return $const");
	return $const;
}

# make #ffffff forms of colors the same based on command line options
# default is long canonical form unless shorten option is given
sub hashColorStandard
{
	my ($color) = @ARG;
	$color = canonical(shorten($color), !opt('shorten'));
	$color =~ s{ $Var{'regex'}{'hashColor'} }{ '#' . lc($1) }xmsge;
	return $color;
}

# make unique version of color based on command line options so that color
# comparisons will work
sub uniqueColor
{
	my ($color) = @ARG;
	return names(formatRgbIshColor(rgb(hashColorStandard($color))));
}

# fix comma spacing in rgb colors
sub formatRgbColor
{
	my ($color) = @ARG;
	$color = commas(trim($color)) if $color =~ $Var{'regex'}{'isRgb'};
	return $color;
}

# fix comma spacing in rgb/hsl colors
sub formatRgbIshColor
{
	my ($color) = @ARG;
	$color = commas(trim($color)) if $color =~ $Var{'regex'}{'isRgbIsh'};
	return $color;
}

sub commas
{
	my ($string) = @ARG;
	$string =~ s{,([^\s])}{, $1}xmsg;
	return $string;
}

# convert #rgb color to #rrggbb so output can be compared against uniqueness
# and lower case the characters
sub canonical
{
	my ($color, $bAlways) = @ARG;
	if ($bAlways || opt('canonical'))
	{
		$color =~ s{
			$Var{'regex'}{'bytesColor'}
		}{
			lc("#$1$2$3")
		}xmsgie;
		$color =~ s{
			$Var{'regex'}{'shortColor'}
		}{
			lc('#' . (substr($1, 0, 1) x 2) .
			(substr($1, 1, 1) x 2) .
			(substr($1, 2, 1) x 2))
		}xmsgie;
	}
	return $color;
}

# convert #rrggbb color to #rgb so output can be compared against uniqueness
# and lower case the characters
sub shorten
{
	my ($color, $bShorten) = @ARG;
	if (opt('shorten') || $bShorten)
	{
		$color =~ s{
			$Var{'regex'}{'canShortenColor'}
		}{
			lc("#$1$2$3")
		}xmsgie;
		$color =~ s{
			$Var{'regex'}{'shortColor'}
		}{
			lc("#$1")
		}xmsgie;
	}
	return $color;
}

# convert #color value to rgb(R,G,B) format
sub rgb
{
	my ($color, $bAlways) = @ARG;
	if (opt('rgb') || $bAlways)
	{
		$color =~ s{
			$Var{'regex'}{'bytesColor'}
		}{
			"rgb(" . hex($1) . ", " . hex($2) . ", " . hex($3) . ")"
		}xmsgie;
		$color =~ s{
			$Var{'regex'}{'shortColor'}
		}{
			my ($red, $green, $blue) = (substr($1, 0, 1), substr($1, 1, 1), substr($1, 2, 1));
			"rgb(" . hex($red . $red) . ", " . hex($green . $green) . ", " . hex($blue . $blue) . ")"
		}xmsgie;
		$color = formatRgbColor($color);
	}
	return $color;
}

# get both rgb and #color version of color
sub getBothColorValues
{
	my ($color) = @ARG;
	my $rgb;

	debug("getBothColorValues(c=$color)", 2);
	if ($color =~ m{ \A (hsl|rgb)\( }xms)
	{
		$rgb = lc(rgbFromHslOrPercent($color));
		$color = canonicalFromRgb($rgb);
	}
	else
	{
		$color = canonical($color, 'force');
		$rgb = rgb($color, 'force');
	}
	debug("getBothColorValues() return (c=$color, r=$rgb)", 3);
	return ($color, $rgb);
}

# convert rgb/hsl format of color to #color form
sub toHashColor
{
	my ($color, $bAlways, $bValid) = @ARG;
	if ($bAlways || opt('hash'))
	{
		my $rgb = rgbFromHslOrPercent($color, $bValid);
		if ($rgb ne $color)
		{
			$color = canonicalFromRgb($rgb, $bValid);
		}
	}
	return $color;
}

# MUSTDO implement foreground/background

# convert color value to color name if names option set
# color could be #rrggbb or r,g,b triplet or r%,g%,b%
# or rgb(...) rgba(...) hsl(...) hsla(...)
# returns name of the color or the original color value
sub names
{
	my ($color) = @ARG;
	if (opt('names'))
	{
		# alpha = 0 is transparent
		$color =~ s{ $Var{'regex'}{'transparent'} }{transparent}xmsg;
		# alpha = 1 is opaque convert to hsl or rgb
		$color =~ s{ $Var{'regex'}{'opaque'} }{$1$2)}xmsg;

		$color = $Var{'rhColorNamesMap'}{lc(rgbFromHslOrPercent($color))} || $color;
		if (!opt('valid-only') && $color =~ m{ $Var{'regex'}{'rgba'} }xms)
		{
			if (exists $Var{'rhColorNamesMap'}{rgbFromHslOrPercent($1)})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{rgbFromHslOrPercent($1)}$2)";
			}
		}
		if (!opt('valid-only') && $color =~ m{ $Var{'regex'}{'hsla'} }xms)
		{
			if (exists $Var{'rhColorNamesMap'}{hsl_to_rgb($1, $2, $3)})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{hsl_to_rgb($1, $2, $3)}$4)";
			}
		}
	}
	return $color;
}

# get rgb value from percentage or hsl
# 100%,100%,100% becomes 255,255,255
# hsla?(h,s%,l%) becomes rgba?(r,g,b)
# hsla(#color, opacity) becomse rgba(#color, opacity) if option --novalid-only
sub rgbFromHslOrPercent
{
	my ($vals, $bValid) = @ARG;
	$bValid = $bValid || opt('valid-only');
	$vals =~ s{ $Var{'regex'}{'hslToRgb'} }{ "rgb$1(" . hsl_to_rgb($2, $3, $4) }xmse;
	$vals =~ s{ $Var{'regex'}{'rgbaCanon'} }{ "rgb$1(" . replacePercent($2) . ',' . replacePercent($3) . ',' . replacePercent($4) }xmse;
	$vals =~ s{ $Var{'regex'}{'hslInvalid'} }{rgba($1}xmsi if !$bValid;
	return formatRgbIshColor($vals);
}

# get #color from rgb() or rgba() (not hsl/hsla)
sub canonicalFromRgb
{
	my ($rgb, $bValid) = @ARG;
	$bValid = $bValid || opt('valid-only');
	$rgb =~ s{ $Var{'regex'}{'rgbCanon'} }{ '#' . toHex($1) . toHex($2) . toHex($3) }xmse;
	if (!$bValid)
	{
		$rgb =~ s{ $Var{'regex'}{'rgbaCanon'} }{ "rgb$1(#" . toHex($2) . toHex($3) . toHex($4) }xmse;
		$rgb = formatRgbIshColor($rgb);
	}
	return $rgb;
}

sub toHex
{
	my ($val) = @ARG;
	return sprintf("%02x", replacePercent($val));
}

sub replacePercent
{
	my ($val) = @ARG;
	$val =~ s{ (\d+) % }{ percentTo255($1) }xmse;
	return $val;
}

sub percentTo255
{
	my ($val) = @ARG;
	return int(0.5 + (255 * $val / 100));
}

# convert a hsl triplet to an rgb triplet
sub hsl_to_rgb
{
	# algorithm from http://www.w3.org/TR/css3-color/#hsl-color
	my ($hue, $sat, $light) = @ARG;
	my ($m1, $m2, $r, $g, $b);

	# First correct for angle outside range [0,360) then make a fraction
	$hue = ((($hue % 360) + 360) % 360);
	$hue /= 360;

	# Convert sat/light to fraction
	$sat /= 100;
	$light /= 100;

	$m2 = ($light <= 0.5) ? $light * ($sat + 1) : $light + $sat - $light * $sat;
	$m1 = $light * 2 - $m2;
	$r = int(255 * hue_to_rgb($m1, $m2, $hue + 1/3));
	$g = int(255 * hue_to_rgb($m1, $m2, $hue));
	$b = int(255 * hue_to_rgb($m1, $m2, $hue - 1/3));
	return formatRgbColor("$r,$g,$b");
}

# convert a hue/sat to rgb value (0-1)
sub hue_to_rgb
{
	# algorithm from http://www.w3.org/TR/css3-color/#hsl-color
	my ($m1, $m2, $h) = @ARG;
	$h = $h + 1 if $h < 0;
	$h = $h - 1 if $h > 1;
	return $m1 + ($m2 - $m1) * $h * 6 if ($h * 6 < 1);
	return $m2 if ($h * 2 < 1);
	return $m1 + ($m2 - $m1) * (2/3 - $h) * 6 if ($h * 3 < 2);
	return $m1;
}

# strip away spaces
sub trim
{
	my ($str) = @ARG;
	$str =~ s{\s+}{}xmsg;
	return $str;
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array
	if (hasOpt('inplace'))
	{
		push(@$raErrors, "You cannot specify standard input when using the --inplace option") if opt($STDIO);
		push(@$raErrors, "You must supply files to process when using the --inplace option.") unless scalar(@$raFiles);
	}
	if (opt('color-only'))
	{
		push(@$raErrors, "You cannot specify --foreground when using the --color-only option") if hasOpt('foreground');
		push(@$raErrors, "You cannot specify --background when using the --color-only option") if hasOpt('background');
	}

	# Force some flags when others turned on
	setOpt('canonical', 1) if (opt('names') || opt('rgb'));
	setOpt('hash', 1) if (opt('names'));
	setOpt('remap', 1) if (opt('names') || opt('canonical') || opt('shorten') || opt('hash'));

	if (opt('canonical'))
	{
		push(@$raErrors, "You cannot specify --shorten when using the --canonical option") if opt('shorten');
	}

	if (opt('rgb'))
	{
		push(@$raErrors, "You cannot specify --names when using the --rgb option") if opt('names');
		push(@$raErrors, "You cannot specify --hash when using the --rgb option") if opt('hash');
	}

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
		tests() if opt('tests');
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

# Unit test plan here

sub tests
{
	eval "use Test::More tests => $TEST_CASES";

	testCanonicalFromRgbValid();
	testCanonicalFromRgbAllowInvalid();
	testRgbFromHslOrPercentValid();
	testRgbFromHslOrPercentAllowInvalid();
	testToHashColorValid();
	testToHashColorAllowInvalid();
	testHashColorStandardShorten();
	testHashColorStandardCanonical();
	testRgb();
	testRenameColorNamesCanonical();
	# test names() function valid only
	# test renameColor() function
	# unittestcall

	my @EveryColorFormat = (
		# #hash or name format
		"#fFf", "#fFfFfF", "#fAfBfC", "white", "red",

		# rgb/hsl
		"rgb(255,255,255)", "rgb(100%,100%,100%)",
		"rgb( 255 , 255 , 255 )", "rgb( 100% , 100% , 100% )",

		"hsl(0,100%,100%)", "hsl( 0 , 100% , 100% )",

		# full opacity
		"rgba(255,255,255,1.0)", "rgba(100%,100%,100%,1.0)",
		"rgba( 255 , 255 , 255 , 1.0 )", "rgba( 100% , 100% , 100% , 1.0 )",
		"hsla(0,100%,100%,1.0)", "hsla( 0 , 100% , 100% , 1.0 )",

		# full transparency
		"transparent",
		"rgba(255,255,255,0.0)", "rgba(100%,100%,100%,0.0)",
		"rgba( 255 , 255 , 255 , 0.0 )", "rgba( 100% , 100% , 100% , 0.0 )",
		"hsla(0,100%,100%,0.0)", "hsla( 0 , 100% , 100% , 0.0 )",

		# partial transparency

		"rgba(255,255,255,0.5)", "rgba(100%,100%,100%,0.5)",
		"rgba( 255 , 255 , 255 , 0.5 )", "rgba( 100% , 100% , 100% , 0.5 )",
		"hsla(0,100%,100%,0.5)", "hsla( 0 , 100% , 100% , 0.5 )",

		# invalid CSS
		"rgba(white,0.5)", "rgba(#fAfBfC,0.5)",
		"rgba( white , 0.5 )", "rgba( #fAfBfC , 0.5 )",
		"hsla(white,0.5)", "hsla( #fAfBfC , 0.5 )",

		# Valid Less
		"rgba(red(\@color),green(\@color),blue(\@color),0.5)",
		"rgba( red( \@color ) , green( \@color ) , blue( \@color ) , 0.5 )",
	);

	exit 0;

	my $bAlways = 1;
	my $bValid = 1;

	my @Result = ();
	foreach my $color (@EveryColorFormat)
	{
		my $result = rgb($color, $bAlways);
		my $expect = "fail";

		push(@Result, $color eq $result ? qq{$color} : qq{$color:$result});

		is($result, $expect, "rgb $color -> $expect");
	}
	wrap("\@RgbTests", \@Result);

}

sub testCanonicalFromRgbValid
{
	my $bValid = 1;
	my @CanonicalFromRgbValidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red', 'rgb(255,255,255):#ffffff',
		'rgb(100%,100%,100%):#ffffff', 'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff',
		'hsl(0,100%,100%)',
		'hsl( 0 , 100% , 100% )', 'rgba(255,255,255,1.0)',
		'rgba(100%,100%,100%,1.0)',
		'rgba( 255 , 255 , 255 , 1.0 )',
		'rgba( 100% , 100% , 100% , 1.0 )',
		'hsla(0,100%,100%,1.0)',
		'hsla( 0 , 100% , 100% , 1.0 )', 'transparent',
		'rgba(255,255,255,0.0)', 'rgba(100%,100%,100%,0.0)',
		'rgba( 255 , 255 , 255 , 0.0 )',
		'rgba( 100% , 100% , 100% , 0.0 )',
		'hsla(0,100%,100%,0.0)',
		'hsla( 0 , 100% , 100% , 0.0 )',
		'rgba(255,255,255,0.5)', 'rgba(100%,100%,100%,0.5)',
		'rgba( 255 , 255 , 255 , 0.5 )',
		'rgba( 100% , 100% , 100% , 0.5 )',
		'hsla(0,100%,100%,0.5)',
		'hsla( 0 , 100% , 100% , 0.5 )',
		'rgba(white,0.5)', 'rgba(#fAfBfC,0.5)', 'rgba( white , 0.5 )',
		'rgba( #fAfBfC , 0.5 )', 'hsla(white,0.5)', 'hsla( #fAfBfC , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 )',
	);

	foreach my $colorResult (@CanonicalFromRgbValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = canonicalFromRgb($color, $bValid);
		is($result, $expect, "canonicalFromRgb (valid) $color -> $expect");
	}
}

sub testCanonicalFromRgbAllowInvalid
{
	my $bValid = 1;
	my @CanonicalFromRgbAllowInvalidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red', 'rgb(255,255,255):#ffffff',
		'rgb(100%,100%,100%):#ffffff', 'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff',
		'hsl(0,100%,100%):hsl(0, 100%, 100%)',
		'hsl( 0 , 100% , 100% ):hsl(0, 100%, 100%)',
		'rgba(255,255,255,1.0):rgba(#ffffff, 1.0)',
		'rgba(100%,100%,100%,1.0):rgba(#ffffff, 1.0)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(#ffffff, 1.0)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(#ffffff, 1.0)',
		'hsla(0,100%,100%,1.0):hsla(0, 100%, 100%, 1.0)',
		'hsla( 0 , 100% , 100% , 1.0 ):hsla(0, 100%, 100%, 1.0)', 'transparent',
		'rgba(255,255,255,0.0):rgba(#ffffff, 0.0)',
		'rgba(100%,100%,100%,0.0):rgba(#ffffff, 0.0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(#ffffff, 0.0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(#ffffff, 0.0)',
		'hsla(0,100%,100%,0.0):hsla(0, 100%, 100%, 0.0)',
		'hsla( 0 , 100% , 100% , 0.0 ):hsla(0, 100%, 100%, 0.0)',
		'rgba(255,255,255,0.5):rgba(#ffffff, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(#ffffff, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(#ffffff, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)',
		'hsla(0,100%,100%,0.5):hsla(0, 100%, 100%, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):hsla(0, 100%, 100%, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'hsla(white,0.5):hsla(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@CanonicalFromRgbAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = canonicalFromRgb($color, !$bValid);
		is($result, $expect, "canonicalFromRgb (!valid) $color -> $expect");
	}
}

sub testRgbFromHslOrPercentValid
{
	my $bValid = 1;
	my @RgbFromHslOrPercentValidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',
		'rgb(255,255,255):rgb(255, 255, 255)',
		'rgb(100%,100%,100%):rgb(255, 255, 255)',
		'rgb( 255 , 255 , 255 ):rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):rgb(255, 255, 255)',
		'hsl(0,100%,100%):rgb(255, 255, 255)',
		'hsl( 0 , 100% , 100% ):rgb(255, 255, 255)',
		'rgba(255,255,255,1.0):rgba(255, 255, 255, 1.0)',
		'rgba(100%,100%,100%,1.0):rgba(255, 255, 255, 1.0)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1.0)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)',
		'hsla(0,100%,100%,1.0):rgba(255, 255, 255, 1.0)',
		'hsla( 0 , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0.0)',
		'rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0.0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0.0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0.0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)', 'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'hsla(white,0.5):hsla(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@RgbFromHslOrPercentValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = rgbFromHslOrPercent($color, $bValid);
		is($result, $expect, "rgbFromHslOrPercent (valid) $color -> $expect");
	}
}

sub testRgbFromHslOrPercentAllowInvalid
{
	my $bValid = 1;
	my @RgbFromHslOrPercentAllowInvalidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',
		'rgb(255,255,255):rgb(255, 255, 255)',
		'rgb(100%,100%,100%):rgb(255, 255, 255)',
		'rgb( 255 , 255 , 255 ):rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):rgb(255, 255, 255)',
		'hsl(0,100%,100%):rgb(255, 255, 255)',
		'hsl( 0 , 100% , 100% ):rgb(255, 255, 255)',
		'rgba(255,255,255,1.0):rgba(255, 255, 255, 1.0)',
		'rgba(100%,100%,100%,1.0):rgba(255, 255, 255, 1.0)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1.0)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)',
		'hsla(0,100%,100%,1.0):rgba(255, 255, 255, 1.0)',
		'hsla( 0 , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0.0)',
		'rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0.0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0.0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0.0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)', 'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@RgbFromHslOrPercentAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = rgbFromHslOrPercent($color, !$bValid);
		is($result, $expect, "rgbFromHslOrPercent (!valid) $color -> $expect");
	}
}

sub testToHashColorValid
{
	my $bAlways = 1;
	my $bValid = 1;
	my @ToHashColorValidTests = (
		"#fFf", "#fFfFfF", "#fAfBfC", "white", "red", "rgb(255,255,255):#ffffff",
		"rgb(100%,100%,100%):#ffffff", "rgb( 255 , 255 , 255 ):#ffffff",
		"rgb( 100% , 100% , 100% ):#ffffff", "hsl(0,100%,100%):#ffffff",
		"hsl( 0 , 100% , 100% ):#ffffff",
		"rgba(255,255,255,1.0):rgba(255, 255, 255, 1.0)",
		"rgba(100%,100%,100%,1.0):rgba(255, 255, 255, 1.0)",
		"rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1.0)",
		"rgba( 100% , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)",
		"hsla(0,100%,100%,1.0):rgba(255, 255, 255, 1.0)",
		"hsla( 0 , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1.0)", "transparent",
		"rgba(255,255,255,0.0):rgba(255, 255, 255, 0.0)",
		"rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0.0)",
		"rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0.0)",
		"rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)",
		"hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0.0)",
		"hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0.0)",
		"rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)",
		"rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)",
		"rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)",
		"rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)",
		"hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)",
		"hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)",
		"rgba(white,0.5):rgba(white, 0.5)", "rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)",
		"rgba( white , 0.5 ):rgba(white, 0.5)",
		"rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)",
		"hsla(white,0.5):hsla(white, 0.5)",
		"hsla( #fAfBfC , 0.5 ):hsla(#fAfBfC, 0.5)",
		"rgba(red(\@color),green(\@color),blue(\@color),0.5):rgba(red(\@color), green(\@color), blue(\@color), 0.5)",
		"rgba( red( \@color ) , green( \@color ) , blue( \@color ) , 0.5 ):rgba(red(\@color), green(\@color), blue(\@color), 0.5)",
	);

	foreach my $colorResult (@ToHashColorValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = toHashColor($color, $bAlways, $bValid);

		is($result, $expect, "toHashColor (valid) $color -> $expect");
	}
}

sub testToHashColorAllowInvalid
{
	my $bAlways = 1;
	my $bValid = 1;
	my @ToHashColorAllowInvalidTests = (
		"#fFf", "#fFfFfF", "#fAfBfC", "white", "red", "rgb(255,255,255):#ffffff",
		"rgb(100%,100%,100%):#ffffff", "rgb( 255 , 255 , 255 ):#ffffff",
		"rgb( 100% , 100% , 100% ):#ffffff", "hsl(0,100%,100%):#ffffff",
		"hsl( 0 , 100% , 100% ):#ffffff",
		"rgba(255,255,255,1.0):rgba(#ffffff, 1.0)",
		"rgba(100%,100%,100%,1.0):rgba(#ffffff, 1.0)",
		"rgba( 255 , 255 , 255 , 1.0 ):rgba(#ffffff, 1.0)",
		"rgba( 100% , 100% , 100% , 1.0 ):rgba(#ffffff, 1.0)",
		"hsla(0,100%,100%,1.0):rgba(#ffffff, 1.0)",
		"hsla( 0 , 100% , 100% , 1.0 ):rgba(#ffffff, 1.0)", "transparent",
		"rgba(255,255,255,0.0):rgba(#ffffff, 0.0)",
		"rgba(100%,100%,100%,0.0):rgba(#ffffff, 0.0)",
		"rgba( 255 , 255 , 255 , 0.0 ):rgba(#ffffff, 0.0)",
		"rgba( 100% , 100% , 100% , 0.0 ):rgba(#ffffff, 0.0)",
		"hsla(0,100%,100%,0.0):rgba(#ffffff, 0.0)",
		"hsla( 0 , 100% , 100% , 0.0 ):rgba(#ffffff, 0.0)",
		"rgba(255,255,255,0.5):rgba(#ffffff, 0.5)",
		"rgba(100%,100%,100%,0.5):rgba(#ffffff, 0.5)",
		"rgba( 255 , 255 , 255 , 0.5 ):rgba(#ffffff, 0.5)",
		"rgba( 100% , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)",
		"hsla(0,100%,100%,0.5):rgba(#ffffff, 0.5)",
		"hsla( 0 , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)",
		"rgba(white,0.5):rgba(white, 0.5)", "rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)",
		"rgba( white , 0.5 ):rgba(white, 0.5)",
		"rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)",
		"hsla(white,0.5):rgba(white, 0.5)",
		"hsla( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)",
		"rgba(red(\@color),green(\@color),blue(\@color),0.5):rgba(red(\@color), green(\@color), blue(\@color), 0.5)",
		"rgba( red( \@color ) , green( \@color ) , blue( \@color ) , 0.5 ):rgba(red(\@color), green(\@color), blue(\@color), 0.5)",
	);

	foreach my $colorResult (@ToHashColorAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = toHashColor($color, $bAlways, !$bValid);

		is($result, $expect, "toHashColor (!valid) $color -> $expect");
	}
}

sub testHashColorStandardShorten
{
	my @HashColorStandardShortenTests = (
		'#fFf:#fff', '#fFfFfF:#fff', '#fAfBfC:#fafbfc', 'white', 'red', 'rgb(255,255,255)',
		'rgb(100%,100%,100%)', 'rgb( 255 , 255 , 255 )',
		'rgb( 100% , 100% , 100% )', 'hsl(0,100%,100%)', 'hsl( 0 , 100% , 100% )',
		'rgba(255,255,255,1.0)', 'rgba(100%,100%,100%,1.0)',
		'rgba( 255 , 255 , 255 , 1.0 )', 'rgba( 100% , 100% , 100% , 1.0 )',
		'hsla(0,100%,100%,1.0)', 'hsla( 0 , 100% , 100% , 1.0 )', 'transparent',
		'rgba(255,255,255,0.0)', 'rgba(100%,100%,100%,0.0)',
		'rgba( 255 , 255 , 255 , 0.0 )', 'rgba( 100% , 100% , 100% , 0.0 )',
		'hsla(0,100%,100%,0.0)', 'hsla( 0 , 100% , 100% , 0.0 )',
		'rgba(255,255,255,0.5)', 'rgba(100%,100%,100%,0.5)',
		'rgba( 255 , 255 , 255 , 0.5 )', 'rgba( 100% , 100% , 100% , 0.5 )',
		'hsla(0,100%,100%,0.5)', 'hsla( 0 , 100% , 100% , 0.5 )',
		'rgba(white,0.5)', 'rgba(#fAfBfC,0.5):rgba(#fafbfc,0.5)', 'rgba( white , 0.5 )',
		'rgba( #fAfBfC , 0.5 ):rgba( #fafbfc , 0.5 )', 'hsla(white,0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla( #fafbfc , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 )',
	);

	setOpt('canonical', 0);
	setOpt('shorten', 1);

	foreach my $colorResult (@HashColorStandardShortenTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = hashColorStandard($color);

		is($result, $expect, "hashColorStandard (shorten) $color -> $expect");
	}

	setOpt('shorten', 0);
}

sub testHashColorStandardCanonical
{
	my @HashColorStandardCanonicalTests = (
		'#fFf:#ffffff', '#fFfFfF:#ffffff', '#fAfBfC:#fafbfc', 'white', 'red',
		'rgb(255,255,255)', 'rgb(100%,100%,100%)', 'rgb( 255 , 255 , 255 )',
		'rgb( 100% , 100% , 100% )', 'hsl(0,100%,100%)', 'hsl( 0 , 100% , 100% )',
		'rgba(255,255,255,1.0)', 'rgba(100%,100%,100%,1.0)',
		'rgba( 255 , 255 , 255 , 1.0 )', 'rgba( 100% , 100% , 100% , 1.0 )',
		'hsla(0,100%,100%,1.0)', 'hsla( 0 , 100% , 100% , 1.0 )', 'transparent',
		'rgba(255,255,255,0.0)', 'rgba(100%,100%,100%,0.0)',
		'rgba( 255 , 255 , 255 , 0.0 )', 'rgba( 100% , 100% , 100% , 0.0 )',
		'hsla(0,100%,100%,0.0)', 'hsla( 0 , 100% , 100% , 0.0 )',
		'rgba(255,255,255,0.5)', 'rgba(100%,100%,100%,0.5)',
		'rgba( 255 , 255 , 255 , 0.5 )', 'rgba( 100% , 100% , 100% , 0.5 )',
		'hsla(0,100%,100%,0.5)', 'hsla( 0 , 100% , 100% , 0.5 )',
		'rgba(white,0.5)', 'rgba(#fAfBfC,0.5):rgba(#fafbfc,0.5)',
		'rgba( white , 0.5 )', 'rgba( #fAfBfC , 0.5 ):rgba( #fafbfc , 0.5 )',
		'hsla(white,0.5)', 'hsla( #fAfBfC , 0.5 ):hsla( #fafbfc , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 )',
	);

	setOpt('shorten', 0);
	setOpt('canonical', 1);

	foreach my $colorResult (@HashColorStandardCanonicalTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = hashColorStandard($color);

		is($result, $expect, "hashColorStandard (canonical) $color -> $expect");
	}

	setOpt('canonical', 0);
}

sub testRenameColorNamesCanonical
{
	my @RenameColorNamesCanonicalTests = (
		'#fFf:white', '#fFfFfF:white', '#fAfBfC:#fafbfc', 'white', 'red',
		'rgb(255,255,255):white', 'rgb(100%,100%,100%):white',
		'rgb( 255 , 255 , 255 ):white', 'rgb( 100% , 100% , 100% ):white',
		'hsl(0,100%,100%):white', 'hsl( 0 , 100% , 100% ):white',
		'rgba(255,255,255,1.0):white',
		'rgba(100%,100%,100%,1.0):white',
		'rgba( 255 , 255 , 255 , 1.0 ):white',
		'rgba( 100% , 100% , 100% , 1.0 ):white',
		'hsla(0,100%,100%,1.0):white',
		'hsla( 0 , 100% , 100% , 1.0 ):white', 'transparent',
		'rgba(255,255,255,0.0):transparent',
		'rgba(100%,100%,100%,0.0):transparent',
		'rgba( 255 , 255 , 255 , 0.0 ):transparent',
		'rgba( 100% , 100% , 100% , 0.0 ):transparent',
		'hsla(0,100%,100%,0.0):transparent',
		'hsla( 0 , 100% , 100% , 0.0 ):transparent',
		'rgba(255,255,255,0.5):rgba(white, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(white, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(white, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(white, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(white, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(white, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(#fafbfc,0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba( #fafbfc , 0.5 )',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla( #fafbfc , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 )',
	);

	setOpt('debug', 5);
	setOpt('canonical', 1);
	setOpt('names', 1);

	readColorNameData();

	foreach my $colorResult (@RenameColorNamesCanonicalTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = renameColor($color);

		is($result, $expect, "renameColor (names,canonical) $color -> $expect");
	}

	setOpt('names', 0);
	setOpt('canonical', 0);
}

sub testRgb
{

	my $bAlways = 1;
	my @RgbTests = (
		'#fFf:rgb(255, 255, 255)', '#fFfFfF:rgb(255, 255, 255)',
		'#fAfBfC:rgb(250, 251, 252)', 'white', 'red',
		'rgb(255,255,255):rgb(255, 255, 255)',
		'rgb(100%,100%,100%):rgb(100%, 100%, 100%)',
		'rgb( 255 , 255 , 255 ):rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):rgb(100%, 100%, 100%)',
		'hsl(0,100%,100%)', 'hsl( 0 , 100% , 100% )',
		'rgba(255,255,255,1.0):rgba(255, 255, 255, 1.0)',
		'rgba(100%,100%,100%,1.0):rgba(100%, 100%, 100%, 1.0)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1.0)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(100%, 100%, 100%, 1.0)',
		'hsla(0,100%,100%,1.0)', 'hsla( 0 , 100% , 100% , 1.0 )', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0.0)',
		'rgba(100%,100%,100%,0.0):rgba(100%, 100%, 100%, 0.0)',
		'rgba( 255 , 255 , 255 , 0.0 )::rgba(255, 255, 255, 0.0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(100%, 100%, 100%, 0.0)',
		'hsla(0,100%,100%,0.0)', 'hsla( 0 , 100% , 100% , 0.0 )',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(100%, 100%, 100%, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(100%, 100%, 100%, 0.5)',
		'hsla(0,100%,100%,0.5)', 'hsla( 0 , 100% , 100% , 0.5 )',
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(rgb(250, 251, 252), 0.5)', # TODO fix!
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(rgb(250, 251, 252), 0.5)',
		'hsla(white,0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla( rgb(250, 251, 252) , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@RgbTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = rgb($color, $bAlways);
		is($result, $expect, "rgb $color -> $expect");
	}
}

# unittestimpl

sub wrap
{
	my ($name, $raTests) = @ARG;
	my $WIDTH = 76;
	my $JOIN = qq{'', };
	my $line = "";
	print STDERR qq{\tmy $name = (\n};
	foreach my $test (@$raTests)
	{
		my $length = length($line);
		if ($length + length($test) + length($JOIN) > $WIDTH)
		{
			print STDERR qq{\t\t$line\n};
			$line = qq{'$test', };
		}
		else
		{
			$line .= qq{'$test', };
		}
	}
	print STDERR qq{\t\t$line\n\t);\n};
}

__DATA__
		aliceblue   #F0F8FF  240,248,255
		antiquewhite   #FAEBD7  250,235,215
		aqua  #00FFFF  0,255,255
		aquamarine  #7FFFD4  127,255,212
		azure #F0FFFF  240,255,255
		beige #F5F5DC  245,245,220
		bisque   #FFE4C4  255,228,196
		black #000000  0,0,0
		blanchedalmond #FFEBCD  255,235,205
		blue  #0000FF  0,0,255
		blueviolet  #8A2BE2  138,43,226
		brown #A52A2A  165,42,42
		burlywood   #DEB887  222,184,135
		cadetblue   #5F9EA0  95,158,160
		chartreuse  #7FFF00  127,255,0
		chocolate   #D2691E  210,105,30
		coral #FF7F50  255,127,80
		cornflowerblue #6495ED  100,149,237
		cornsilk #FFF8DC  255,248,220
		crimson  #DC143C  220,20,60
		cyan  #00FFFF  0,255,255
		darkblue #00008B  0,0,139
		darkcyan #008B8B  0,139,139
		darkgoldenrod  #B8860B  184,134,11
		darkgray #A9A9A9  169,169,169
		darkgreen   #006400  0,100,0
		darkgrey #A9A9A9  169,169,169
		darkkhaki   #BDB76B  189,183,107
		darkmagenta #8B008B  139,0,139
		darkolivegreen #556B2F  85,107,47
		darkorange  #FF8C00  255,140,0
		darkorchid  #9932CC  153,50,204
		darkred  #8B0000  139,0,0
		darksalmon  #E9967A  233,150,122
		darkseagreen   #8FBC8F  143,188,143
		darkslateblue  #483D8B  72,61,139
		darkslategray  #2F4F4F  47,79,79
		darkslategrey  #2F4F4F  47,79,79
		darkturquoise  #00CED1  0,206,209
		darkviolet  #9400D3  148,0,211
		deeppink #FF1493  255,20,147
		deepskyblue #00BFFF  0,191,255
		dimgray  #696969  105,105,105
		dimgrey  #696969  105,105,105
		dodgerblue  #1E90FF  30,144,255
		firebrick   #B22222  178,34,34
		floralwhite #FFFAF0  255,250,240
		forestgreen #228B22  34,139,34
		fuchsia  #FF00FF  255,0,255
		gainsboro   #DCDCDC  220,220,220
		ghostwhite  #F8F8FF  248,248,255
		gold  #FFD700  255,215,0
		goldenrod   #DAA520  218,165,32
		gray  #808080  128,128,128
		green #008000  0,128,0
		greenyellow #ADFF2F  173,255,47
		grey  #808080  128,128,128
		honeydew #F0FFF0  240,255,240
		hotpink  #FF69B4  255,105,180
		indianred   #CD5C5C  205,92,92
		indigo   #4B0082  75,0,130
		ivory #FFFFF0  255,255,240
		khaki #F0E68C  240,230,140
		lavender #E6E6FA  230,230,250
		lavenderblush  #FFF0F5  255,240,245
		lawngreen   #7CFC00  124,252,0
		lemonchiffon   #FFFACD  255,250,205
		lightblue   #ADD8E6  173,216,230
		lightcoral  #F08080  240,128,128
		lightcyan   #E0FFFF  224,255,255
		lightgoldenrodyellow #FAFAD2  250,250,210
		lightgray   #D3D3D3  211,211,211
		lightgreen  #90EE90  144,238,144
		lightgrey   #D3D3D3  211,211,211
		lightpink   #FFB6C1  255,182,193
		lightsalmon #FFA07A  255,160,122
		lightseagreen  #20B2AA  32,178,170
		lightskyblue   #87CEFA  135,206,250
		lightslategray #778899  119,136,153
		lightslategrey #778899  119,136,153
		lightsteelblue #B0C4DE  176,196,222
		lightyellow #FFFFE0  255,255,224
		lime  #00FF00  0,255,0
		limegreen   #32CD32  50,205,50
		linen #FAF0E6  250,240,230
		magenta  #FF00FF  255,0,255
		maroon   #800000  128,0,0
		mediumaquamarine  #66CDAA  102,205,170
		mediumblue  #0000CD  0,0,205
		mediumorchid   #BA55D3  186,85,211
		mediumpurple   #9370DB  147,112,219
		mediumseagreen #3CB371  60,179,113
		mediumslateblue   #7B68EE  123,104,238
		mediumspringgreen #00FA9A  0,250,154
		mediumturquoise   #48D1CC  72,209,204
		mediumvioletred   #C71585  199,21,133
		midnightblue   #191970  25,25,112
		mintcream   #F5FFFA  245,255,250
		mistyrose   #FFE4E1  255,228,225
		moccasin #FFE4B5  255,228,181
		navajowhite #FFDEAD  255,222,173
		navy  #000080  0,0,128
		oldlace  #FDF5E6  253,245,230
		olive #808000  128,128,0
		olivedrab   #6B8E23  107,142,35
		orange   #FFA500  255,165,0
		orangered   #FF4500  255,69,0
		orchid   #DA70D6  218,112,214
		palegoldenrod  #EEE8AA  238,232,170
		palegreen   #98FB98  152,251,152
		paleturquoise  #AFEEEE  175,238,238
		palevioletred  #DB7093  219,112,147
		papayawhip  #FFEFD5  255,239,213
		peachpuff   #FFDAB9  255,218,185
		peru  #CD853F  205,133,63
		pink  #FFC0CB  255,192,203
		plum  #DDA0DD  221,160,221
		powderblue  #B0E0E6  176,224,230
		purple   #800080  128,0,128
		red   #FF0000  255,0,0
		rosybrown   #BC8F8F  188,143,143
		royalblue   #4169E1  65,105,225
		saddlebrown #8B4513  139,69,19
		salmon   #FA8072  250,128,114
		sandybrown  #F4A460  244,164,96
		seagreen #2E8B57  46,139,87
		seashell #FFF5EE  255,245,238
		sienna   #A0522D  160,82,45
		silver   #C0C0C0  192,192,192
		skyblue  #87CEEB  135,206,235
		slateblue   #6A5ACD  106,90,205
		slategray   #708090  112,128,144
		slategrey   #708090  112,128,144
		snow  #FFFAFA  255,250,250
		springgreen #00FF7F  0,255,127
		steelblue   #4682B4  70,130,180
		tan   #D2B48C  210,180,140
		teal  #008080  0,128,128
		thistle  #D8BFD8  216,191,216
		tomato   #FF6347  255,99,71
		turquoise   #40E0D0  64,224,208
		violet   #EE82EE  238,130,238
		wheat #F5DEB3  245,222,179
		white #FFFFFF  255,255,255
		whitesmoke  #F5F5F5  245,245,245
		yellow   #FFFF00  255,255,0
		yellowgreen #9ACD32  154,205,50
