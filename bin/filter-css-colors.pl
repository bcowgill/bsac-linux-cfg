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
	--trace          negatable. turn on some debug trace.
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
 Implies --canonical unless you have specified --shorten.
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
 Implies --canonical unless you have specified --shorten.
 Cannot use --names or --hash with --rgb.

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

 Replace hard coded colors with values from a variable definition file

 filter-css-colors.pl --noecho --inplace=.bak --remap --shorten --valid-only --const-file variables.less styles/*.less

=head1 TODO

use cases:
convert rgba(r,g,b,a) to rgba(red(),green(),blue(),alpha)
extract all unique color values and define them as consecutive constant names but leave them as is in the files

support for:
  border: 2px solid #ffffff;

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

our $TEST_CASES = 625;
our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";
our $HASH    = '\#';
our $CLOSE_THRESHOLD = 0.1;

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
			trace   => 0,
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
			"trace!",
			"tests!",        # run the unit tests
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	'raColorNames' => ['transparent'],
	'constantContext'     => '',    # option or line where constant is defined
	'rhColorNamesMap'     => {},
	'rhConstantsMap'      => {},      # @const => #color
	'rhUndefinedConstantsMap' => {}, # @const1 => @const2
	'raAutoConstants'     => [],
	'rhColorConstantsMap' => {}, # #color => [@const, ... ]
	'regex' => {
		'data'            => qr{ \A \s* (\w+) \s+ ( $HASH [0-9a-f]{6} ) \s+ ( \d+,\d+,\d+ ) }xmsi,
		'cssConst'        => qr{ ( \. ([-\w]+) -defined \s* \{ \s* color \s* : \s* ([^;]+) \s* ; \s* \}) }xms,
		'constDef'        => qr{ ( [\@\$] ([-\w]+) \s* : \s* ([^;]+) \s* ; ) }xms,
		'names'           => '', # populated in setup()
		'line'            => '', # populated in setup()
		'isHashColor'     => qr{\A $HASH }xms,
		'hashColor'       => qr{ $HASH ([0-9a-f]{3,6}) \b }xmsi,
		'shortColor'      => qr{ $HASH ([0-9a-f]{3}) \b }xmsi,
		'canShortenColor' => qr{ $HASH ([0-9a-f])\1 ([0-9a-f])\2 ([0-9a-f])\3 \b }xmsi,
		'bytesColor'      => qr{ $HASH ([0-9a-f]{2}) ([0-9a-f]{2}) ([0-9a-f]{2}) \b }xmsi,
		'isRgb'           => qr{ \A rgb \( }xmsi,
		'isRgbRgba'       => qr{ \A rgb a? \( }xmsi,
		'isRgbIsh'        => qr{ \A (rgb|hsl) a? \( }xmsi,
		'isRgbHsl'        => qr{ \A (rgb|hsl)? \( }xmsi,
		'isRgbHashAlpha'  => qr{ \A rgba \( [a-z$HASH] }xmsi,
		'rgbAnything'     => qr{ \A rgb \( (.+) \) \z }xmsi,
		'rgbUnwrap'       => qr{ \A ( (?:rgb|hsl) a \( ) (.+) ( , \s* [0-9\.]+ \) ) \z }xmsi,
		'rgbaRgbUnwrap'   => qr{ ( rgba \( ) \s* rgb \( \s* ( \d+ \%? \s* , \s* \d+ \%? \s* , \s* \d+ \%? ) \s* \) \s* ( , \s* [0-9\.]+ \s* \) ) }xms,
		'rgbAlphaUnwrap'  => qr{ \A (rgb|hsl) a \( (.+) , \s* ([0-9\.]+) \s* \) \z }xmsi,
		'transparent'     => qr{ (rgb|hsl) a \( ([^\)]+?) , \s* [0\.]+ \s* \) }xmsi,
		'opaque'          => qr{ (rgb|hsl) a ( \( [^\)]+ ) , \s* 0*[1-9]\d*(\.0*)? \s* \) }xmsi,
		'rgbCanon'        => qr{ rgb     \( \s* ( \d+ \%?) \s* , \s* (\d+ \%?) \s* , \s* (\d+ \%?)    \s* \) }xmsi,
		'rgba'            => qr{ \A rgba \( \s* ( \d+ \%?  \s* , \s*  \d+ \%?  \s* , \s*  \d+ \%? ) ( \s* , \s* [^\)]+ ) \) }xmsi,
		'hslToRgb'        => qr{ hsl(a?) \( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% \s* }xmsi,
		'rgbaCanon'       => qr{ rgb(a?) \( \s* (\d+ \%?) \s* , \s* (\d+ \%?) \s* , \s* (\d+ \%?) \s* }xmsi,
		'rgbaValid'       => qr{ \A rgba \( \s* red\( ([^\)]+) \) \s* , \s* green\( ([^\)]+) \) \s* , \s* blue\( ([^\)]+) \) \s* , \s* ([^,]+) \s* \) }xmsi,
		'rgbaInvalid'     => qr{ (?:rgb|hsl)a \( \s* ([^,]+) \s* , \s* ([^,]+) \s* \) }xmsi,
		'rgbaRedGreenBlue' => qr{ rgba \( \s* red\( ([^\)]+) \) \s* , \s* green\( \1 \) \s* , \s* blue\( \1 \) \s* , \s* ([^,]+) \s* \) }xmsi,
		'hslInvalid'      => qr{ \A hsla \( \s* (\w+| $HASH [0-9a-f]{3,6}) }xmsi,
		'hsla'            => qr{ \A hsla \( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% ( \s* , \s* [^\)]+ ) \) }xmsi,
	},
);

# Return the value of a command line option
# NO TEST CASE
sub opt
{
	my ($opt) = @ARG;
	return defined($opt) ?
		$Var{'rhArg'}{'rhOpt'}{$opt} :
		$Var{'rhArg'}{'rhOpt'};
}

# NO TEST CASE
sub hasOpt
{
	my ($opt) = @ARG;
	return exists( $Var{'rhArg'}{'rhOpt'}{$opt} );
}

# NO TEST CASE
sub setOpt
{
	my ( $opt, $value ) = @ARG;
	return $Var{'rhArg'}{'rhOpt'}{$opt} = $value;
}

# NO TEST CASE
sub arg
{
	my ($arg) = @ARG;
	return defined($arg) ?
		$Var{'rhArg'}{$arg} :
		$Var{'rhArg'};
}

# NO TEST CASE
sub setArg
{
	my ( $arg, $value ) = @ARG;
	return $Var{'rhArg'}{$arg} = $value;
}

getOptions();

# NO TEST CASE
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

# NO TEST CASE
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

# NO TEST CASE
sub summary
{
	showAutoConstants();
}

####################################
# methods used by setup

# NO TEST CASE
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
			$rgb = formatRgbColor($rgb);
			push(@{$Var{'raColorNames'}}, $name);
			$Var{'rhColorNamesMap'}{$color} = $name;
			$color = shorten($color);
			$Var{'rhColorNamesMap'}{$color} = $name;

			$Var{'rhColorNamesMap'}{"rgb($rgb)"} = $name;
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

# NO TEST CASE
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

# NO TEST CASE
sub processConstantFiles
{
	debug("processConstantFiles()\n");
	my $raFiles = opt('const-file');
	foreach my $file (@$raFiles)
	{
		processConstantFile($file);
	}
}

# NO TEST CASE
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

# NO TEST CASE
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

# NO TEST CASE
sub showConstantsTable
{
	debug("showConstantsTable()\n");
	debug("constants: " . Dumper($Var{'rhConstantsMap'}), 2);
	debug("colors" . Dumper($Var{'rhColorConstantsMap'}), 2);

	my $mode = opt('rgb') ? 'RGB color' : '#color';
	print "// $mode constant definitions:\n";
	foreach my $color (sort(keys(%{$Var{'rhColorConstantsMap'}})))
	{
		my $printed = 0;
		foreach my $const (sort(@{$Var{'rhColorConstantsMap'}{$color}}))
		{
			my $print = 1;
			if ($color =~ $Var{'regex'}{'isRgbHashAlpha'})
			{
				$print = 0 if opt('rgb');
			}
			elsif ($color =~ $Var{'regex'}{'isRgbIsh'})
			{
				$print = 0 unless opt('rgb');
			}
			elsif ($color =~ $Var{'regex'}{'isHashColor'})
			{
				$print = 0 if opt('rgb');
			}
			if ($print)
			{
				$color = userRenameColorValid($color);
				print "$const: $color;\n"
			}
			$printed += $print;
		}
		print "\n" if $printed;
	}
}

####################################
# methods used by main

# NO TEST CASE
sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $raContent = read_file(\*STDIN, array_ref => 1);
	doReplacement( $raContent );
	print join("", @$raContent);
}

# NO TEST CASE
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

# NO TEST CASE
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

# NO TEST CASE
sub processEntireFile
{
	my ($fileName) = @ARG;
	debug("processEntireFile($fileName)\n");

	$Var{fileName} = $fileName;
	my $raContent = read_file($fileName, array_ref => 1);
	doReplacement( $raContent );
	print join("", @$raContent);
}

####################################
# methods used by summary

# NO TEST CASE
sub showAutoConstants
{
	debug("showAutoConstants()", 1);
	my $out = opt('const-pull');
	my $bValidOnly = 1;
	if ($out)
	{
		debug("showAutoConstants() raAutoConstants" . Dumper($Var{'raAutoConstants'}), 3);
		debug("showAutoConstants() rhColorConstantsMap" . Dumper($Var{'rhColorConstantsMap'}), 3);
		debug("showAutoConstants() rhConstantsMap" . Dumper($Var{'rhConstantsMap'}), 3);
		my $fh;
		if ($out eq '-')
		{
			debug("showAutoConstants() stdout", 2);
			$fh = *STDOUT;
		}
		else
		{
			debug("showAutoConstants() $out", 2);
			open($fh, '>>', $out);
		}
		foreach my $color (@{$Var{'raAutoConstants'}})
		{
			# TODO selectively show #color or rgb based on opt rgb
			debug("showAutoConstants() color $color", 3);
			my $const = lookupColorConstantsMap($color)->[0];
			debug("showAutoConstants() const $const", 3);
			my $comment = niceNameColor($color, !$bValidOnly);
			debug("showAutoConstants() comment $comment", 3);
			$comment = ($comment eq $color) ? '' : " // $comment";
			print $fh "$const: $color;$comment\n";
		}
		close($fh) unless ($out eq '-');
	}
}

####################################
# methods initially used by setup

# fix comma spacing in rgb colors
# NO TEST CASE
sub formatRgbColor
{
	my ($color) = @ARG;
	$color = commas(trim($color)) if $color =~ $Var{'regex'}{'isRgbRgba'};
	return $color;
}

# convert #rrggbb color to #rgb based on command line options
# NO TEST CASE
sub userShorten
{
	my ($color, $bShorten) = @ARG;
	if (opt('shorten') || $bShorten)
	{
		$color = shorten($color);
	}
	return $color;
}

# convert #rrggbb color to #rgb so output can be compared against uniqueness
# and lower case the characters
# NO TEST CASE
sub shorten
{
	my ($color) = @ARG;

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

	return $color;
}

# NO TEST CASE
sub isUsingLess
{
	return opt('const-type') =~ m{\A [l\@]}xmsi;
}

# NO TEST CASE
sub isUsingSass
{
	return opt('const-type') =~ m{\A [s\$]}xmsi;
}

# NO TEST CASE
sub isConstOrColor
{
	my ($const) = @ARG;
	debug("isConstOrColor($const)", 4);
	return isConst($const) || isColor($const);
}

# NO TEST CASE
sub isConst
{
	my ($const) = @ARG;
	my $prefix = q{\\} . opt('const-type');
	my $regex = qr{\A $prefix}xms;
	debug("isConst($const) $regex " . $const =~ $regex, 4);
	return $const =~ $regex;
}

# NO TEST CASE
sub isColor
{
	my ($value) = @ARG;
	my $regex = qr{
		\A $Var{'regex'}{'line'} \z
	}xms;

	debug("isColor($value) $regex " . $value =~ $regex, 4);
	return $value =~ $regex;
}

# NO TEST CASE
sub checkConstName
{
	my ($const) = @ARG;
	my $prefix = q{\\} . opt('const-type');
	$const =~ m{\A $prefix [-\w]+ \z}xms || die "MUSTDO constant name/expression not supported [$const]";
}

# NO TEST CASE
sub registerConstantFromFile
{
	my ($const, $value, $match) = @ARG;
	$match = trimToOne($match);
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

#xyzzy

# NO TEST CASE
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
		addColorConstantsMap($const, $value);
		return 1;
	}
	return 0;
}

# NO TEST CASE
sub addColorConstantsMap
{
	my ($const, $color) = @ARG;

	debug("addColorConstantsMap($const, $color)", 2);
	my $rgb;
	($color, $rgb) = getBothColorValues($color);
	push( @{ $Var{'rhColorConstantsMap'}{$rgb} }, $const );
	if (trimEq($color, $rgb))
	{
		debug("addColorConstantsMap($const) 2 r=$rgb", 3);
		$Var{'rhConstantsMap'}{$const} = $rgb;
	}
	else
	{
		debug("addColorConstantsMap($const) 3 c=$color r=$rgb", 3);
		$Var{'rhConstantsMap'}{$const} = $color;
		push( @{ $Var{'rhColorConstantsMap'}{$color} }, $const );
	}
}

# NO TEST CASE
sub lookupColorConstantsMap
{
	my ($color) = @ARG;

	debug("lookupColorConstantsMap($color)", 2);
	my $rgb;
	($color, $rgb) = getBothColorValues($color);
	return $Var{'rhColorConstantsMap'}{$color} || $Var{'rhColorConstantsMap'}{$rgb};
}

# rename a color value based on command line options but ensuring valid CSS
# will make unique version of color based on command line options so that color
# comparisons will work
# HAS TEST CASE
sub userRenameColorValid
{
	my ($color) = @ARG;
	debug("userRenameColorValid($color)", 2);
	my $bValidOnly = 1;
	my $bAlways = 1;
	return rgbRedGreenBlueFromRgba(trace('colorNames',
        userColorNames(trace('rgbFromHashColor',
            userRgbFromHashColor(trace('hashColorStd',
                userHashColorStandard(trace('toHashColor',
                    userToHashColor($color, !$bAlways, $bValidOnly)
                ))
            ))
        ))
    ));
}

####################################
# methods used by methods in main

# NO TEST CASE
sub doReplacement
{
	my ( $raContent ) = @ARG;
	foreach my $line (@$raContent)
	{
		$line = doReplaceLine($line);
	}
	return $raContent;
}

# NO TEST CASE
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

####################################
# methods used by methods in summary (in showAutoConstants)

# get the nicest name for a color possible. i.e. white
# or rgba(white, 0.3) for partial opacity
# or ~white for something close to white
# or transparent red, partially red, tinted red, mostly red for rgba values
# HAS TEST CASE
sub niceNameColor
{
	my ($color) = @ARG;
	debug("\nniceNameColor($color)", 1);
	my $bValidOnly = 1;
	my ($adjective, $name);
	($color, $adjective) = alphaColorName($color);
	$color = rgbFromHashColor(
		colorNames(
			hashColorStandard(
				toHashColor($color)
			),
			!$bValidOnly
		)
	);
	$name = $adjective ? "$adjective $color" : $color;
	return $name;
}

####################################

# put a single space after commas
# NO TEST CASE
sub commas
{
	my ($string) = @ARG;
	$string =~ s{,([^\s])}{, $1}xmsg;
	return $string;
}

# strip away all spaces
# NO TEST CASE
sub trim
{
	my ($str) = @ARG;
	$str =~ s{\s+}{}xmsg;
	return $str;
}

# strip away multiple spaces leaving one
# NO TEST CASE
sub trimToOne
{
	my ($str) = @ARG;
	$str =~ s{\s\s*}{ }xmsg;
	return $str;
}

# strip away all leading space in string
# NO TEST CASE
sub trimLeading
{
	my ($str) = @ARG;
	$str =~ s{\A \s*}{}xms;
	return $str;
}

# strip away all leading and trailing space in string
# NO TEST CASE
sub trimAround
{
	my ($str) = @ARG;
	$str =~ s{\s* \z}{}xms;
	return trimLeading($str);
}

# compare ignoring spaces
# NO TEST CASE
sub trimEq
{
	my ($a, $b) = @ARG;
	return trim($a) eq trim($b);
}

####################################

# NO TEST CASE
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

# NO TEST CASE
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

# NO TEST CASE
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

# remap color values in place, where possible
# this may not produce valid CSS output.
# for example rgba(0,0,0,0.5) can become rgba(black,0.5)
# NO TEST CASE
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

# NO TEST CASE
sub substituteConstants
{
	my ($color, $line) = @ARG;

	my $origColor = $color;
	debug("substituteConstants($color, $line)", 3);
	$color = lookupConstant(userRenameColor($color));
	debug("substituteConstants() lookup $color", 3);
	if (isConst($color))
	{
		debug("substituteConstants() constant $color", 3);
	}
	elsif (opt('const-pull'))
	{
		$color = defineAutoConstant($color, $origColor, $line);
		debug("substituteConstants() define $color", 3);
	}
	else
	{
		$color = userRenameColor($origColor);
		debug("substituteConstants() nodefine $origColor $color", 3);
	}

	debug("substituteConstants() out $color", 3);
	return $color;
}

# Given a color value see if there is a constant already defined
# for that color value. Returns the constant name or original
# color if none.
# NO TEST CASE
sub lookupConstant
{
	my ($color) = @ARG;
	debug("lookupConstant($color)", 2);
	my $raConstants = lookupColorConstantsMap($color);
	if ($raConstants)
	{
		$color = $raConstants->[0];
		if (opt('const-list') && (scalar(@$raConstants) > 1))
		{
			$color .= qq{ /* @{[join(', ', @$raConstants)]}*/};
		}
	}
	return $color;
}

# rename a color value based on command line options
# HAS TEST CASE
sub userRenameColor
{
	my ($color) = @ARG;
	return userColorNames(
		userRgbFromHashColor(
			userHashColorStandard(
				userToHashColor($color)
			)
		)
	);
}

# convert color value to color name if names option set
# color could be #rrggbb or r,g,b triplet or r%,g%,b%
# or rgb(...) rgba(...) hsl(...) hsla(...)
# returns name of the color or the original color value
# NO TEST CASE
sub userColorNames
{
	my ($color) = @ARG;
	debug("userColorNames($color)", 2);
	if (opt('names'))
	{
		$color = colorNames($color, opt('valid-only'));
	}
	return $color;
}

# NO TEST CASE
sub colorNames
{
	my ($color, $bValidOnly) = @ARG;
	debug("colorNames($color, @{[$bValidOnly || 0]})", 2);
#	debug("rhColorNamesMap" . Dumper($Var{'rhColorNamesMap'}, 4)) if $color eq 'rgba(255, 255, 255, 0.4)';

	# handle the special case rgba(red(#color)..., alpha)
	if ($color =~ $Var{'regex'}{'rgbaValid'})
	{
		$color =~ s{ $Var{'regex'}{'rgbaValid'} }{
			'rgba(red(' . colorNames($1)
			. '), green(' . colorNames($2)
			. '), blue(' . colorNames($3)
			. '), ' . toAlpha($4)
			. ')'
		}xmse;
		return $color;
	}

	$color = opaqueOrTransparent($color);
	debug("colorNames() 1 $color", 4);

	$color = $Var{'rhColorNamesMap'}{trim($color)} || $color;
	debug("colorNames() 2 color names map $color", 4);

	my $rgb = lc(rgbFromHslOrPercent($color));
	$color = $Var{'rhColorNamesMap'}{trim($rgb)} || $color;
	debug("colorNames() 3 $color rgb=$rgb", 4);

	$rgb =~ s{$Var{'regex'}{'rgbAnything'}}{$1}xms;
	$color = $Var{'rhColorNamesMap'}{trim($rgb)} || $color;
	debug("colorNames() 4 rgb anything $color", 4);

	# handle the special case rgba(#color, alpha)
	if ($rgb =~ s{ $Var{'regex'}{'rgbUnwrap'} }{$2}xms)
	{
		my ($prefix, $postfix) = ($1, $3);
		debug("colorNames() 5 $prefix $rgb $postfix", 4);

		if ($Var{'rhColorNamesMap'}{$rgb})
		{
			debug("colorNames() 6 $rgb", 4);
			$color = "$prefix$Var{'rhColorNamesMap'}{$rgb}$postfix";
		}
	}

	if (!$bValidOnly)
	{
		debug("colorNames() 7 allow invalid", 4);
		if ($color =~ m{ $Var{'regex'}{'rgba'} }xms)
		{
			my $match = $1;
			$rgb = trim(rgbFromHslOrPercent($match));
			debug("colorNames() 8 $color match=$1 rgb=$rgb", 4);
			if (exists $Var{'rhColorNamesMap'}{$rgb})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{$rgb}$2)";
				debug("colorNames() 9 $color", 4);
			}
		}
		debug("colorNames() 10 $color", 4);
		if ($color =~ m{ $Var{'regex'}{'hsla'} }xms)
		{
			$rgb = rgbFromHsl($1, $2, $3);
			debug("colorNames() 11 hsla $1 $2 $3", 4);
			if (exists $Var{'rhColorNamesMap'}{$rgb})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{$rgb}$4)";
				debug("colorNames() 12 $color", 4);
			}
		}
	}
	debug("colorNames() 13 $color", 4);
	return $color;
}

# NO TEST CASE
sub opaqueOrTransparent
{
	my ($color) = @ARG;;

	debug("opaqueOrTransparent($color)", 2);

	# alpha = 0 is transparent
	$color =~ s{ $Var{'regex'}{'transparent'} }{transparent}xmsg;
	debug("opaqueOrTransparent() 1 $color", 4);

	# alpha = 1 is opaque convert to hsl or rgb
	$color =~ s{ $Var{'regex'}{'opaque'} }{$1$2)}xmsg;
	debug("opaqueOrTransparent() 2 $color", 4);

	return $color;
}

# NO TEST CASE
sub alphaColorName
{
	my ($color) = @ARG;

	debug("alphaColorName($color)", 2);

	my $adjective = '';
	$color = rgbInvalidFromRedGreenBlue($color);
	my $isRgbInvalid = $color =~ $Var{'regex'}{'rgbaInvalid'};
	$color =~ s{
			$Var{'regex'}{'rgbAlphaUnwrap'}
		}{
			$color = trim($2);
			$adjective = alphaNiceName($3);
			$isRgbInvalid ? $color : qq{$1($color)}
		}xmseg;
	debug("alphaColorName() 1 $adjective $color", 4);

	return ($color, $adjective);
}

# HAS INDIRECT TEST CASE
sub alphaNiceName
{
	my ($alpha) = @ARG;

	my $name = '';
	$alpha = 0.0 + $alpha;
	debug("alphaNiceName($alpha)", 4);

	if ($alpha == 0)
	{
		$name = 'transparent';
	}
	elsif ($alpha < 0.25)
	{
		$name = 'a touch of';
	}
	elsif ($alpha < 0.5)
	{
		$name = 'partially';
	}
	elsif ($alpha < 0.75)
	{
		$name = 'tinted';
	}
	elsif ($alpha < 1.0)
	{
		$name = 'mostly';
	}

	return $name;
}

# convert #color value to rgb(R,G,B) format based on command line options
# NO TEST CASE
sub userRgbFromHashColor
{
	my ($color, $bAlways) = @ARG;
	if (opt('rgb') || $bAlways)
	{
		$color = rgbFromHashColor($color);
	}
	return $color;
}

# convert #color value to rgb(R,G,B) format
# HAS TEST CASE
sub rgbFromHashColor
{
	my ($color) = @ARG;

	debug("rgbFromHashColor($color)", 1);
	$color =~ s{
		$Var{'regex'}{'bytesColor'}
	}{
		"rgb(" . hex($1) . ", " . hex($2) . ", " . hex($3) . ")"
	}xmsgie;
	debug("rgbFromHashColor 1 $color", 3);

	$color =~ s{
		$Var{'regex'}{'shortColor'}
	}{
		my ($red, $green, $blue) = (substr($1, 0, 1), substr($1, 1, 1), substr($1, 2, 1));
		"rgb(" . hex($red . $red) . ", " . hex($green . $green) . ", " . hex($blue . $blue) . ")"
	}xmsgie;
	debug("rgbFromHashColor 2 $color", 3);

	$color =~ s{ $Var{'regex'}{'rgbaRgbUnwrap'} }{$1$2$3}xms;
	debug("rgbFromHashColor 3 $color", 3);

	$color = formatRgbColor($color);
	debug("rgbFromHashColor 4 $color", 3);

	return $color;
}

# make #ffffff forms of colors the same based on command line options
# default is long canonical form unless shorten option is given
# HAS TEST CASE
sub userHashColorStandard
{
	my ($color) = @ARG;
	$color = userCanonical(userShorten($color), !opt('shorten'));
	$color =~ s{ $Var{'regex'}{'hashColor'} }{ '#' . lc($1) }xmsge;
	return $color;
}

# make hash colors standard for lowercase #ffffff
# NO TEST CASE
sub hashColorStandard
{
	my ($color) = @ARG;
	debug("hashColorStandard($color)", 3);
	$color = canonical($color);
	$color =~ s{ $Var{'regex'}{'hashColor'} }{ '#' . lc($1) }xmsge;
	return $color;
}

# convert rgb/hsl format of color to #color form based on command line options
# HAS TEST CASE
sub userToHashColor
{
	my ($color, $bAlways, $bValidOnly) = @ARG;
	if ($bAlways || opt('hash'))
	{
		my $rgb = rgbFromHslOrPercent($color, $bValidOnly);
		if ($rgb ne $color)
		{
			$color = userCanonicalFromRgb($rgb, $bValidOnly);
		}
		if ($bValidOnly)
		{
			$color = rgbRedGreenBlueFromRgba($color);
		}
	}
	return $color;
}

# NO TEST CASE
sub toHashColor
{
	my ($color, $bValidOnly) = @ARG;
	my $rgb = rgbFromHslOrPercent($color, $bValidOnly);
	if ($rgb ne $color)
	{
		$color = canonicalFromRgb($rgb, $bValidOnly);
	}
	return $color;
}

# NO TEST CASE
sub defineAutoConstant
{
	my ($color, $origColor, $match) = @ARG;
	debug("defineAutoConstant($color, $origColor, $match)");

	my $const = $color;
	if (isColorOkToConvertToConstant($color, $origColor, $match))
	{
		$const = opt('const-type') . "autoConstant" . scalar(@{$Var{'raAutoConstants'}});
		$color = userRenameColorValid($color);
		push(@{$Var{'raAutoConstants'}}, $color);
		registerConstantFromFile($const, $color, $match);
	}
	debug("defineAutoConstant() return $const");
	return $const;
}

# fix comma spacing in rgb/hsl colors
# fix alpha value to a normal form
# NO TEST CASE
sub formatRgbIshColor
{
	my ($color) = @ARG;
	if ($color =~ $Var{'regex'}{'isRgbIsh'})
	{
		$color = commas(trim($color));
		$color =~ s{(,) ([^,]+) (\)) \z}{"$1 " . toAlpha($2) . $3}xmse;

	}
	return $color;
}

# create rgb(red(),green(),blue(),alpha) from a rgba(#color,alpha) string
# NO TEST CASE
sub rgbRedGreenBlueFromRgba
{
	my ($rgba) = @ARG;

	if ($rgba !~ m{ $Var{'regex'}{'rgbaValid'} }xms)
	{
		$rgba =~ s{ $Var{'regex'}{'rgbaInvalid'} }{
			my $alpha = toAlpha($2);
			qq{rgba(red($1), green($1), blue($1), $alpha)};
		}xmse;
	}
	return $rgba;
}

# create rgb(color,alpha) from rgb(red(color)...)
# NO TEST CASE
sub rgbInvalidFromRedGreenBlue
{
	my ($rgba) = @ARG;
	$rgba =~ s{ $Var{'regex'}{'rgbaRedGreenBlue'} }{
		my $alpha = toAlpha($2);
		qq{rgba($1, $alpha)};
	}xmse;
	return $rgba;
}

# convert #rgb color to #rrggbb based on user settings
# NO TEST CASE
sub userCanonical
{
	my ($color, $bAlways) = @ARG;
	if ($bAlways || opt('canonical'))
	{
		$color = canonical($color);
	}
	return $color;
}

# convert #rgb color to #rrggbb so output can be compared against uniqueness
# and lower case the characters
# NO TEST CASE
sub canonical
{
	my ($color) = @ARG;

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

	return $color;
}

# get both rgb and #color version of color
# HAS TEST CASE
sub getBothColorValues
{
	my ($color) = @ARG;
	my $rgb;

	debug("getBothColorValues(c=$color)", 2);
	if ($color =~ $Var{'regex'}{'isRgbIsh'})
	{
		debug("getBothColorValues 2 isrgbhsl", 3);
		$rgb = lc(formatRgbIshColor(rgbFromHslOrPercent($color)));
		$color = canonicalFromRgb($rgb);
	}
	else
	{
		$color = canonical($color);
		$rgb = formatRgbIshColor(rgbFromHashColor($color, 'force'));
	}
	debug("getBothColorValues() return (c=$color, r=$rgb)", 3);
	return ($color, $rgb);
}

# MUSTDO implement foreground/background

# get rgb value from percentage or hsl
# 100%,100%,100% becomes 255,255,255
# hsla?(h,s%,l%) becomes rgba?(r,g,b)
# hsla(#color, alpha) becomes rgba(#color, alpha) if option --novalid-only
# HAS TEST CASE
sub rgbFromHslOrPercent
{
	my ($vals, $bValidOnly) = @ARG;
	$bValidOnly = $bValidOnly || opt('valid-only');
	$vals =~ s{ $Var{'regex'}{'hslToRgb'} }{ "rgb$1(" . rgbFromHsl($2, $3, $4) }xmse;
	$vals =~ s{ $Var{'regex'}{'rgbaCanon'} }{ "rgb$1(" . replacePercent($2) . ',' . replacePercent($3) . ',' . replacePercent($4) }xmse;
	$vals =~ s{ $Var{'regex'}{'hslInvalid'} }{rgba($1}xmsi if !$bValidOnly;
	return formatRgbIshColor($vals);
}

# get #color from rgb(), rgba(), hsl(), or hsla()
# HAS TEST CASE
sub userCanonicalFromRgb
{
	my ($rgb, $bValidOnly) = @ARG;
	$bValidOnly = $bValidOnly || opt('valid-only');
	$rgb = canonicalFromRgb($rgb, $bValidOnly);
	return $rgb;
}

# HAS INDIRECT TEST CASE
sub canonicalFromRgb
{
	my ($rgb, $bValidOnly) = @ARG;
	$rgb = rgbFromHslOrPercent($rgb, $bValidOnly);
	$rgb =~ s{ $Var{'regex'}{'opaque'} }{ "$1$2)" }xmse;
	$rgb =~ s{ $Var{'regex'}{'rgbCanon'} }{ '#' . toHex($1) . toHex($2) . toHex($3) }xmse;
	if (!$bValidOnly)
	{
		$rgb =~ s{ $Var{'regex'}{'rgbaCanon'} }{ "rgb$1(#" . toHex($2) . toHex($3) . toHex($4) }xmse;
		$rgb = rgbInvalidFromRedGreenBlue($rgb);
		$rgb = formatRgbIshColor($rgb);
	}
	return $rgb;
}

# NO TEST CASE
sub toHex
{
	my ($val) = @ARG;
	return sprintf("%02x", replacePercent($val));
}

# convert an alpha value to canonical form
# i.e. 0001.23 would be 1.23
# NO TEST CASE
sub toAlpha
{
	my ($val) = @ARG;

	if ($val =~ m{[^0-9\.\s]}xms)
	{
		return trimAround(trimToOne($val));
	}
	return 0.0 + $val;
}

# NO TEST CASE
sub replacePercent
{
	my ($val) = @ARG;
	$val =~ s{ (\d+) % }{ percentTo255($1) }xmse;
	return $val;
}

# NO TEST CASE
sub percentTo255
{
	my ($val) = @ARG;
	return int(0.5 + (255 * $val / 100));
}

# return the closest named colors to a specific #color value
# will look in the standard HTML color names as well as any defiend constants
# HAS TEST CASE
sub getClosestColors
{
	my ($color) = @ARG;

	debug("getClosestColors($color)", 2);
	my @ClosestColors = ();

	foreach my $namedColor (keys(%{$Var{'rhColorNamesMap'}})) {
		next unless $namedColor =~ $Var{'regex'}{'bytesColor'};
		my $name = $Var{'rhColorNamesMap'}{$namedColor};
		my $closeness = colorCloseness($color, $namedColor);
		debug("getClosestColors $namedColor $name $closeness", 3);
		next unless $closeness <= $CLOSE_THRESHOLD;
		push(@ClosestColors, [$name, $closeness]);
	}

	# now look through defined variables to see how close we are

	my @Sorted = sort sortByCloseness @ClosestColors;
	return @Sorted[0 .. min(2, scalar(@Sorted - 1))];
}

# NO TEST CASE
sub niceNameClosestColors
{
	my ($color) = @ARG;

	my @ClosestColors = getClosestColors($color);
	if (scalar(@ClosestColors)) {
		$color = join(",", map { tildeCloseness($ARG->[1]) . $ARG->[0] } @ClosestColors);
	}
	return $color;
}

# NO TEST CASE
sub tildeCloseness
{
	my ($closeness) = @ARG;

	my $tildes = "~";
	$tildes .= "~" if $closeness < $CLOSE_THRESHOLD / 2;
	$tildes .= "~" if $closeness < $CLOSE_THRESHOLD / 4;
	return $tildes;
}

# NO TEST CASE
sub min
{
	my ($min, @vars) = @_;
	for my $value (@vars) {
		$min = $value if $value < $min;
	}
	return $min;
}

# NO TEST CASE
sub max
{
	my ($max, @vars) = @_;
	for my $value (@vars) {
		$max = $value if $value > $max;
	}
	return $max;
}

# NO TEST CASE
sub sortByCloseness
{
	debug("sortByCloseness(@{[Dumper($a)]}, @{[Dumper($b)]})", 8);
	return $a->[1] <=> $b->[1];
}

# HAS TEST CASE
sub colorCloseness
{
	my ($color1, $color2) = @ARG;
	my $raVector1 = vectorFromRgb(rgbFromHashColor($color1));
	my $raVector2 = vectorFromRgb(rgbFromHashColor($color2));
	return vectorCloseness($raVector1, $raVector2);
}

# vector functions for checking how close two colors are
# HAS INDIRECT TEST CASE
sub vectorColor
{
	my ($red, $green, $blue) = @ARG;
	my $raVector = [256 + $red, 256 + $green, 256 + $blue];
	return $raVector;
}

# HAS INDIRECT TEST CASE
sub vectorMagnitude
{
	my ($raVector) = @ARG;
	my $magnitude = 0;
	for (my $idx = 0; $idx < scalar(@$raVector); ++$idx)
	{
		$magnitude += $raVector->[$idx] * $raVector->[$idx];
	}
	return sqrt($magnitude);
}

# HAS INDIRECT TEST CASE
sub vectorSubtract
{
	my ($raVector1, $raVector2) = @ARG;
	my $raDifference = [];
	for (my $idx = 0; $idx < scalar(@$raVector1); ++$idx)
	{
		$raDifference->[$idx] = $raVector1->[$idx] - $raVector2->[$idx];
	}
	return $raDifference;
}

# HAS INDIRECT TEST CASE
sub vectorCloseness
{
	my ($raVector1, $raVector2) = @ARG;
	my $magnitude = vectorMagnitude($raVector1);
	my $raDifference = vectorSubtract($raVector1, $raVector2);
	return vectorMagnitude($raDifference) / $magnitude;
}

# HAS INDIRECT TEST CASE
sub vectorFromRgb
{
	my ($rgb) = @ARG;
	$rgb =~ s{rgb\(}{}xmsg;
	$rgb =~ s{\)}{}xmsg;
	my @Vector = split(',', $rgb);
	return \@Vector;
}

# convert a hsl triplet to an rgb triplet
# NO TEST CASE
sub rgbFromHsl
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
	$r = int(255 * rgbFromHue($m1, $m2, $hue + 1/3));
	$g = int(255 * rgbFromHue($m1, $m2, $hue));
	$b = int(255 * rgbFromHue($m1, $m2, $hue - 1/3));
	return formatRgbColor("$r,$g,$b");
}

# convert a hue/sat to rgb value (0-1)
# NO TEST CASE
sub rgbFromHue
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

# Must manually check mandatory values present
# NO TEST CASE
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
	setOpt('canonical', 1) if (!opt('shorten') && (opt('names') || opt('rgb')));
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

# NO TEST CASE
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
# NO TEST CASE
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
# NO TEST CASE
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

# NO TEST CASE
sub warning
{
	my ($warning) = @ARG;
	warn( "WARN: " . tab($warning) . "\n" );
}

# NO TEST CASE
sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	print tab($msg) . "\n" if ( opt('debug') >= $level );
}

# NO TEST CASE
sub trace
{
	my ($label, $what) = @ARG;
	print "$label: $what\n" if opt('trace');
	return $what;
}

# NO TEST CASE
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

# NO TEST CASE
sub manual
{
	pod2usage(
		-exitval => 0,
		-verbose => 2,
	);
}

# Unit test plan here
# Show which functions have test cases:
# grep -A 1 'TEST CASE' filter-css-colors.pl | grep -v -- '--' | perl -ne 'if ($saved) {print "$saved $_"; $saved = undef;} else {chomp; $saved = $_;}' | grep -v filter-css-colors | sort
# Show how many times functions without a test case are called
# perl -MData::Dumper -ne 'if (m{# \s* NO \s+ TEST \s+ CASE}xms) { $no_test = 1;} s{((\w+)\()}{$Calls{$2}++; $1}xmsge; if (m{\A \s* sub \s+ (\w+)}xms) { warn "redefined function $1\n" if $Functions{$1};  $Functions{$1} = 0 if $no_test; $no_test = 0; } END {my @Keys = sort { $Calls{$b} <=> $Calls{$a} } keys(%Functions); foreach my $function (@Keys) { print "$function $Calls{$function}\n" if $Calls{$function} > 1}}' filter-css-colors.pl

sub tests
{
	eval "use Test::More tests => $TEST_CASES";

	readColorNameData();

	testRgbFromHslOrPercentValid();
	testRgbFromHslOrPercentAllowInvalid();
	testRgbFromHashColor();
	testGetBothColorValues();
	testNiceNameColor();
	testColorCloseness();

	testUserCanonicalFromRgbAllowInvalid();
	testUserCanonicalFromRgbValid();
	testUserToHashColorValid();
	testUserToHashColorAllowInvalid();
	testUserHashColorStandardShorten();
	testUserHashColorStandardCanonical();

	testUserRenameColorNamesCanonicalAllowInvalid();
	testUserRenameColorNamesCanonical();
	testUserRenameColorValid();
	testGetClosestColors();
	testNiceNameClosestColors();

	# unittestcall

	my @EveryColorFormat = (
		# #hash or name format
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',

		# rgb/hsl
		'rgb(255,255,255)', 'rgb(100%,100%,100%)',
		'rgb( 255 , 255 , 255 )', 'rgb( 100% , 100% , 100% )',
		'rgb(1%,212,41%)', 'rgb(1%,20%,41%)',

		'hsl(0,100%,100%)', 'hsl( 0 , 100% , 100% )',

		# full opacity
		'rgba(255,255,255,1.0)', 'rgba(100%,100%,100%,1.0)',
		'rgba( 255 , 255 , 255 , 1.0 )', 'rgba( 100% , 100% , 100% , 1.0 )',
		'rgba(1%,212,41%,1.0)', 'rgba(1%,20%,41%,1.0)',
		'hsla(0,100%,100%,1.0)', 'hsla( 0 , 100% , 100% , 1.0 )',

		# full transparency
		'transparent',
		'rgba(255,255,255,0.0)', 'rgba(100%,100%,100%,0.0)',
		'rgba( 255 , 255 , 255 , 0.0 )', 'rgba( 100% , 100% , 100% , 0.0 )',
		'hsla(0,100%,100%,0.0)', 'hsla( 0 , 100% , 100% , 0.0 )',

		# partial transparency

		'rgba(255,255,255,0.5)', 'rgba(100%,100%,100%,0.5)',
		'rgba( 255 , 255 , 255 , 0.5 )', 'rgba( 100% , 100% , 100% , 0.5 )',
		'rgba(1%,212,41%,0.2)', 'rgba(1%,20%,41%,0.2)',
		'hsla(0,100%,100%,0.5)', 'hsla( 0 , 100% , 100% , 0.5 )',

		# invalid CSS
		'rgba(white,0.5)', 'rgba(#fAfBfC,0.5)',
		'rgba( white , 0.5 )', 'rgba( #fAfBfC , 0.5 )',
		'hsla(white,0.5)', 'hsla( #fAfBfC , 0.5 )',

		# Valid Less
		'rgba(red(@color1), green(@color), blue(@color), 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 )',
	);

	exit 0 unless opt('tests') > 1;

	setOpt('canonical', 1);
	setOpt('hash', 1);
	setOpt('names', 1);
#	setOpt('remap', 1);
#	setOpt('valid-only', 1);

	my $bAlways = 1;
	my $bValidOnly = 1;

	my @Result = ();
	foreach my $color (@EveryColorFormat)
	{
		my @result = trace($color);
		my $result = join(':', @result);
		my $expect = "fail";

		push(@Result, $color eq $result ? qq{$color} : qq{$color:$result});

		is($result, $expect, "userUniqueColor $color -> $expect");
	}
	wrap("\@UserUniqueColorTests", \@Result);
	exit 0;
}

sub testUserCanonicalFromRgbValid
{
	my $count = 1;
	my $bValidOnly = 1;
	my @UserCanonicalFromRgbValidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red', 'rgb(255,255,255):#ffffff',
		'rgb(1%,212,41%):#03d469',
		'rgb(1%,20%,41%):#033369',
		'rgba(1%,212,41%,1.0):#03d469',
		'rgba(1%,20%,41%,1.0):#033369',
		'rgba(1%,212,41%,0.2):rgba(3, 212, 105, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(3, 51, 105, 0.2)',
		'rgb(100%,100%,100%):#ffffff', 'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff',
		'hsl(0,100%,100%):#ffffff',
		'hsl( 0 , 100% , 100% ):#ffffff', 'rgba(255,255,255,1.0):#ffffff',
		'rgba(100%,100%,100%,1.0):#ffffff',
		'rgba( 255 , 255 , 255 , 1.0 ):#ffffff',
		'rgba( 100% , 100% , 100% , 1.0 ):#ffffff',
		'hsla(0,100%,100%,1.0):#ffffff',
		'hsla( 0 , 100% , 100% , 1.0 ):#ffffff', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0)', 'rgba(255,255,255,0.0):rgba(255, 255, 255, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)', 'rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)', 'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)', 'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)', 'hsla(white,0.5):hsla(white, 0.5)', 'hsla( #fAfBfC , 0.5 ):hsla(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@UserCanonicalFromRgbValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

        # indirect test of canonicalFromRgb()
		my $result = userCanonicalFromRgb($color, $bValidOnly);
		is($result, $expect, $count++ .") userCanonicalFromRgb (valid) $color -> $expect");
	}
}

sub testUserCanonicalFromRgbAllowInvalid
{
	my $count = 1;
	my $bValidOnly = 1;
	my @UserCanonicalFromRgbAllowInvalidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',
		'rgb(255,255,255):#ffffff',
		'rgb(1%,212,41%):#03d469',
		'rgb(1%,20%,41%):#033369',
		'rgba(1%,212,41%,1.0):#03d469',
		'rgba(1%,20%,41%,1.0):#033369',
		'rgba(1%,212,41%,0.2):rgba(#03d469, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(#033369, 0.2)',
		'rgb(100%,100%,100%):#ffffff',
		'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff',
		'hsl(0,100%,100%):#ffffff',
		'hsl( 0 , 100% , 100% ):#ffffff',
		'rgba(255,255,255,1.0):#ffffff',
		'rgba(100%,100%,100%,1.0):#ffffff',
		'rgba( 255 , 255 , 255 , 1.0 ):#ffffff',
		'rgba( 100% , 100% , 100% , 1.0 ):#ffffff',
		'hsla(0,100%,100%,1.0):#ffffff',
		'hsla( 0 , 100% , 100% , 1.0 ):#ffffff',
		'transparent',
		'rgba(255,255,255,0.0):rgba(#ffffff, 0)',
		'rgba(100%,100%,100%,0.0):rgba(#ffffff, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(#ffffff, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(#ffffff, 0)',
		'hsla(0,100%,100%,0.0):rgba(#ffffff, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(#ffffff, 0)',
		'rgba(255,255,255,0.5):rgba(#ffffff, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(#ffffff, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(#ffffff, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(#ffffff, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(@color, 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(@color, 0.5)',
	);

	foreach my $colorResult (@UserCanonicalFromRgbAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

        # indirect test of canonicalFromRgb()
		my $result = userCanonicalFromRgb($color, !$bValidOnly);
		is($result, $expect, $count++ . ") userCanonicalFromRgb (!valid) $color -> $expect");
	}
}

sub testRgbFromHslOrPercentValid
{
	my $count = 1;
	my $bValidOnly = 1;
	my @RgbFromHslOrPercentValidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',
		'rgb(1%,212,41%):rgb(3, 212, 105)',
		'rgb(1%,20%,41%):rgb(3, 51, 105)',
		'rgba(1%,212,41%,1.0):rgba(3, 212, 105, 1)',
		'rgba(1%,20%,41%,1.0):rgba(3, 51, 105, 1)',
		'rgba(1%,212,41%,0.2):rgba(3, 212, 105, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(3, 51, 105, 0.2)',
		'rgb(255,255,255):rgb(255, 255, 255)',
		'rgb(100%,100%,100%):rgb(255, 255, 255)',
		'rgb( 255 , 255 , 255 ):rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):rgb(255, 255, 255)',
		'hsl(0,100%,100%):rgb(255, 255, 255)',
		'hsl( 0 , 100% , 100% ):rgb(255, 255, 255)',
		'rgba(255,255,255,1.0):rgba(255, 255, 255, 1)',
		'rgba(100%,100%,100%,1.0):rgba(255, 255, 255, 1)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1)',
		'hsla(0,100%,100%,1.0):rgba(255, 255, 255, 1)',
		'hsla( 0 , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1)', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0)',
		'rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
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

		my $result = rgbFromHslOrPercent($color, $bValidOnly);
		is($result, $expect, $count++ . ") rgbFromHslOrPercent (valid) $color -> $expect");
	}
}

sub testRgbFromHslOrPercentAllowInvalid
{
	my $count = 1;
	my $bValidOnly = 1;
	my @RgbFromHslOrPercentAllowInvalidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red',
		'rgb(255,255,255):rgb(255, 255, 255)',
		'rgb(100%,100%,100%):rgb(255, 255, 255)',
		'rgb( 255 , 255 , 255 ):rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):rgb(255, 255, 255)',
		'hsl(0,100%,100%):rgb(255, 255, 255)',
		'hsl( 0 , 100% , 100% ):rgb(255, 255, 255)',
		'rgba(255,255,255,1.0):rgba(255, 255, 255, 1)',
		'rgba(100%,100%,100%,1.0):rgba(255, 255, 255, 1)',
		'rgba( 255 , 255 , 255 , 1.0 ):rgba(255, 255, 255, 1)',
		'rgba( 100% , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1)',
		'hsla(0,100%,100%,1.0):rgba(255, 255, 255, 1)',
		'hsla( 0 , 100% , 100% , 1.0 ):rgba(255, 255, 255, 1)', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0)',
		'rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
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

		my $result = rgbFromHslOrPercent($color, !$bValidOnly);
		is($result, $expect, $count++ . ") rgbFromHslOrPercent (!valid) $color -> $expect");
	}
}

sub testUserToHashColorValid
{
	my $count = 1;
	my $bAlways = 1;
	my $bValidOnly = 1;
	my @ToHashColorValidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red', 'rgb(255,255,255):#ffffff',
		'rgb(1%,212,41%):#03d469',
		'rgb(1%,20%,41%):#033369',
		'rgba(1%,212,41%,1.0):#03d469',
		'rgba(1%,20%,41%,1.0):#033369',
		'rgba(1%,212,41%,0.2):rgba(3, 212, 105, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(3, 51, 105, 0.2)',
		'rgb(100%,100%,100%):#ffffff', 'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff', 'hsl(0,100%,100%):#ffffff',
		'hsl( 0 , 100% , 100% ):#ffffff',
		'rgba(255,255,255,1.0):#ffffff',
		'rgba(100%,100%,100%,1.0):#ffffff',
		'rgba( 255 , 255 , 255 , 1.0 ):#ffffff',
		'rgba( 100% , 100% , 100% , 1.0 ):#ffffff',
		'hsla(0,100%,100%,1.0):#ffffff',
		'hsla( 0 , 100% , 100% , 1.0 ):#ffffff', 'transparent',
		'rgba(255,255,255,0.0):rgba(255, 255, 255, 0)',
		'rgba(100%,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'hsla(0,100%,100%,0.0):rgba(255, 255, 255, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(255, 255, 255, 0)',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba(white,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba(#fAfBfC,0.5):rgba(red(#fAfBfC), green(#fAfBfC), blue(#fAfBfC), 0.5)',
		'rgba( white , 0.5 ):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(red(#fAfBfC), green(#fAfBfC), blue(#fAfBfC), 0.5)',
		'hsla(white,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(red(#fAfBfC), green(#fAfBfC), blue(#fAfBfC), 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@ToHashColorValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userToHashColor($color, $bAlways, $bValidOnly);

		is($result, $expect, $count++ . ") userToHashColor (valid) $color -> $expect");
	}
}

sub testUserToHashColorAllowInvalid
{
	my $count = 1;
	my $bAlways = 1;
	my $bValidOnly = 1;
	my @UserToHashColorAllowInvalidTests = (
		'#fFf', '#fFfFfF', '#fAfBfC', 'white', 'red', 'rgb(255,255,255):#ffffff',
		'rgb(1%,212,41%):#03d469',
		'rgb(1%,20%,41%):#033369',
		'rgba(1%,212,41%,1.0):#03d469',
		'rgba(1%,20%,41%,1.0):#033369',
		'rgba(1%,212,41%,0.2):rgba(#03d469, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(#033369, 0.2)',
		'rgb(100%,100%,100%):#ffffff', 'rgb( 255 , 255 , 255 ):#ffffff',
		'rgb( 100% , 100% , 100% ):#ffffff', 'hsl(0,100%,100%):#ffffff',
		'hsl( 0 , 100% , 100% ):#ffffff',
		'rgba(255,255,255,1.0):#ffffff',
		'rgba(100%,100%,100%,1.0):#ffffff',
		'rgba( 255 , 255 , 255 , 1.0 ):#ffffff',
		'rgba( 100% , 100% , 100% , 1.0 ):#ffffff',
		'hsla(0,100%,100%,1.0):#ffffff',
		'hsla( 0 , 100% , 100% , 1.0 ):#ffffff', 'transparent',
		'rgba(255,255,255,0.0):rgba(#ffffff, 0)',
		'rgba(100%,100%,100%,0.0):rgba(#ffffff, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(#ffffff, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(#ffffff, 0)',
		'hsla(0,100%,100%,0.0):rgba(#ffffff, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(#ffffff, 0)',
		'rgba(255,255,255,0.5):rgba(#ffffff, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(#ffffff, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(#ffffff, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(#ffffff, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5)',
		'rgba(white,0.5):rgba(white, 0.5)', 'rgba(#fAfBfC,0.5):rgba(#fAfBfC, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(#fAfBfC, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(@color, 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(@color, 0.5)',
	);

	foreach my $colorResult (@UserToHashColorAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userToHashColor($color, $bAlways, !$bValidOnly);

		is($result, $expect, $count++ . ") userToHashColor (!valid) $color -> $expect");
	}
}

sub testUserHashColorStandardShorten
{
	my $count = 1;
	my @UserHashColorStandardShortenTests = (
		'#fFf:#fff', '#fFfFfF:#fff', '#fAfBfC:#fafbfc', 'white', 'red', 'rgb(255,255,255)',
		'rgb(1%,212,41%):rgb(1%,212,41%)',
		'rgb(1%,20%,41%):rgb(1%,20%,41%)',
		'rgba(1%,212,41%,1.0):rgba(1%,212,41%,1.0)',
		'rgba(1%,20%,41%,1.0):rgba(1%,20%,41%,1.0)',
		'rgba(1%,212,41%,0.2):rgba(1%,212,41%,0.2)',
		'rgba(1%,20%,41%,0.2):rgba(1%,20%,41%,0.2)',
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

	foreach my $colorResult (@UserHashColorStandardShortenTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userHashColorStandard($color);

		is($result, $expect, $count++ . ") userHashColorStandard (shorten) $color -> $expect");
	}

	setOpt('shorten', 0);
}

sub testUserHashColorStandardCanonical
{
	my $count = 1;
	my @UserHashColorStandardCanonicalTests = (
		'#fFf:#ffffff', '#fFfFfF:#ffffff', '#fAfBfC:#fafbfc', 'white', 'red',
		'rgb(1%,212,41%):rgb(1%,212,41%)',
		'rgb(1%,20%,41%):rgb(1%,20%,41%)',
		'rgba(1%,212,41%,1.0):rgba(1%,212,41%,1.0)',
		'rgba(1%,20%,41%,1.0):rgba(1%,20%,41%,1.0)',
		'rgba(1%,212,41%,0.2):rgba(1%,212,41%,0.2)',
		'rgba(1%,20%,41%,0.2):rgba(1%,20%,41%,0.2)',
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

	foreach my $colorResult (@UserHashColorStandardCanonicalTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userHashColorStandard($color);

		is($result, $expect, $count++ . ") userHashColorStandard (canonical) $color -> $expect");
	}

	setOpt('canonical', 0);
}

sub testRgbFromHashColor
{
	my $count = 1;
	my $bAlways = 1;
	my @RgbFromHashColorTests = (
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
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(255, 255, 255, 0.0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(100%, 100%, 100%, 0.0)',
		'hsla(0,100%,100%,0.0)', 'hsla( 0 , 100% , 100% , 0.0 )',
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(100%, 100%, 100%, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(100%, 100%, 100%, 0.5)',
		'hsla(0,100%,100%,0.5)', 'hsla( 0 , 100% , 100% , 0.5 )',
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(250, 251, 252, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(250, 251, 252, 0.5)',
		'hsla(white,0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla( rgb(250, 251, 252) , 0.5 )',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	foreach my $colorResult (@RgbFromHashColorTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = rgbFromHashColor($color);
		is($result, $expect, $count++ . ") rgb $color -> $expect");
	}
}

sub testUserRenameColorNamesCanonicalAllowInvalid
{
	my $count = 1;
	my @UserRenameColorNamesCanonicalAllowInvalidTests = (
		'#fFf:white', '#fFfFfF:white', '#fAfBfC:#fafbfc', 'white', 'red',
		'rgb(1%,212,41%):#03d469',
		'rgb(1%,20%,41%):#033369',
		'rgba(1%,212,41%,1.0):#03d469',
		'rgba(1%,20%,41%,1.0):#033369',
		'rgba(1%,212,41%,0.2):rgba(#03d469, 0.2)',
		'rgba(1%,20%,41%,0.2):rgba(#033369, 0.2)',
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
		'rgba(#fAfBfC,0.5):rgba(#fafbfc, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fafbfc, 0.5)',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(#fafbfc, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(@color, 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(@color, 0.5)',
	);

	#setOpt('debug', 5);
	setOpt('canonical', 1);
	setOpt('hash', 1);
	setOpt('names', 1);
	setOpt('remap', 1);

	foreach my $colorResult (@UserRenameColorNamesCanonicalAllowInvalidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userRenameColor($color);

		is($result, $expect, $count++ . ") userRenameColor (!valid,names,canonical) $color -> $expect");
	}

	setOpt('names', 0);
	setOpt('canonical', 0);
	setOpt('hash', 0);
	setOpt('remap', 0);
}

sub testUserRenameColorNamesCanonical
{
	my $count = 1;
	my @UserRenameColorNamesCanonicalValidOnlyTests = (
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
		'rgba(255,255,255,0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(255, 255, 255, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',

		# degenerate cases from invalid input
		'rgba(white,0.5):rgba(white, 0.5)', 'rgba(#fAfBfC,0.5):rgba(#fafbfc, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fafbfc, 0.5)',
		'hsla(white,0.5):hsla(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):hsla(#fafbfc, 0.5)',
	);

	#setOpt('debug', 5);
	setOpt('canonical', 1);
	setOpt('hash', 1);
	setOpt('names', 1);
	setOpt('remap', 1);
	setOpt('valid-only', 1);

	foreach my $colorResult (@UserRenameColorNamesCanonicalValidOnlyTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userRenameColor($color);

		is($result, $expect, $count++ . ") userRenameColor (valid,names,canonical) $color -> $expect");
	}

	setOpt('names', 0);
	setOpt('canonical', 0);
	setOpt('hash', 0);
	setOpt('remap', 0);
	setOpt('valid-only', 0);
}

sub testGetBothColorValues
{
	my $count = 0;
	my @GetBothColorValuesTests = (
		'#fFf:#ffffff:rgb(255, 255, 255)', '#fFfFfF:#ffffff:rgb(255, 255, 255)',
		'#fAfBfC:#fafbfc:rgb(250, 251, 252)', 'white:white:white', 'red:red:red',
		'rgb(255,255,255):#ffffff:rgb(255, 255, 255)',
		'rgb(100%,100%,100%):#ffffff:rgb(255, 255, 255)',
		'rgb( 255 , 255 , 255 ):#ffffff:rgb(255, 255, 255)',
		'rgb( 100% , 100% , 100% ):#ffffff:rgb(255, 255, 255)',
		'hsl(0,100%,100%):#ffffff:rgb(255, 255, 255)',
		'hsl( 0 , 100% , 100% ):#ffffff:rgb(255, 255, 255)',
		'rgba(255,255,255,1.0):#ffffff:rgba(255, 255, 255, 1)',
		'rgba(100%,100%,100%,1.0):#ffffff:rgba(255, 255, 255, 1)',
		'rgba( 255 , 255 , 255 , 1.0 ):#ffffff:rgba(255, 255, 255, 1)',
		'rgba( 100% , 100% , 100% , 1.0 ):#ffffff:rgba(255, 255, 255, 1)',
		'hsla(0,100%,100%,1.0):#ffffff:rgba(255, 255, 255, 1)',
		'hsla( 0 , 100% , 100% , 1.0 ):#ffffff:rgba(255, 255, 255, 1)',
		'transparent:transparent:transparent',
		'rgba(255,255,255,0.0):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'rgba(100%,100%,100%,0.0):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'rgba( 255 , 255 , 255 , 0.0 ):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'rgba( 100% , 100% , 100% , 0.0 ):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'hsla(0,100%,100%,0.0):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'hsla( 0 , 100% , 100% , 0.0 ):rgba(#ffffff, 0):rgba(255, 255, 255, 0)',
		'rgba(255,255,255,0.5):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'hsla(0,100%,100%,0.5):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(#ffffff, 0.5):rgba(255, 255, 255, 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(@color, 0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(@color, 0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',

		# input we cannot do a thing with
		'rgba(red(@color1), green(@color), blue(@color), 0.5)',

		# degenerate results from invalid input
		'rgba(white,0.5):rgba(white, 0.5)',
		'rgba(#fAfBfC,0.5):rgba(#fafbfc, 0.5)',
		'rgba( white , 0.5 ):rgba(white, 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(#fafbfc, 0.5)',
		'hsla(white,0.5):rgba(white, 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(#fafbfc, 0.5)',
	);

	#setOpt('debug', 5);

	foreach my $colorResult (@GetBothColorValuesTests)
	{
		++$count;
		#next unless $count == 32;
		my ($color, $expectColor, $expectRgb) = split(/:/, $colorResult);
		$expectColor = $expectColor || $color;
		$expectRgb = $expectRgb || $expectColor;

		my ($gotColor, $gotRgb) = getBothColorValues($color);

		is($gotColor, $expectColor, $count . "a) getBothColorValues color $color -> $expectColor");
		is($gotRgb, $expectRgb, $count . "b) getBothColorValues rgb  $color -> $expectRgb");
	}
}

sub testNiceNameColor
{
	my $count = 1;
	my @NiceNameColorTests = (
		'#fFf:white', '#fFfFfF:white', '#fAfBfC:rgb(250, 251, 252)', 'white', 'red',
		'rgb(255,255,255):white', 'rgb(100%,100%,100%):white',
		'rgb( 255 , 255 , 255 ):white', 'rgb( 100% , 100% , 100% ):white',
		'hsl(0,100%,100%):white', 'hsl( 0 , 100% , 100% ):white',
		'rgba(255,255,255,1.0):white', 'rgba(100%,100%,100%,1.0):white',
		'rgba( 255 , 255 , 255 , 1.0 ):white',
		'rgba( 100% , 100% , 100% , 1.0 ):white', 'hsla(0,100%,100%,1.0):white',
		'hsla( 0 , 100% , 100% , 1.0 ):white', 'transparent white',
		'rgba(255,255,255,0.0):transparent white',
		'rgba(100%,100%,100%,0.0):transparent white',
		'rgba( 255 , 255 , 255 , 0.0 ):transparent white',
		'rgba( 100% , 100% , 100% , 0.0 ):transparent white',
		'hsla(0,100%,100%,0.0):transparent white',
		'hsla( 0 , 100% , 100% , 0.0 ):transparent white',
		'rgba(255,255,255,0.24):a touch of white',
		'rgba(255,255,255,0.25):partially white',
		'rgba(255,255,255,0.49):partially white',
		'rgba(255,255,255,0.50):tinted white',
		'rgba(255,255,255,0.74):tinted white',
		'rgba(255,255,255,0.75):mostly white',
		'rgba(255,255,255,0.99):mostly white',
		'rgba(100%,100%,100%,0.5):tinted white',
		'rgba( 255 , 255 , 255 , 0.5 ):tinted white',
		'rgba( 100% , 100% , 100% , 0.5 ):tinted white',
		'hsla(0,100%,100%,0.5):tinted white',
		'hsla( 0 , 100% , 100% , 0.5 ):tinted white',
		'rgba(white,0.5):tinted white', 'rgba(#fAfBfC,0.5):tinted rgb(250, 251, 252)',
		'rgba( white , 0.5 ):tinted white',
		'rgba( #fAfBfC , 0.5 ):tinted rgb(250, 251, 252)',
		'hsla(white,0.5):tinted white',
		'hsla( #fAfBfC , 0.5 ):tinted rgb(250, 251, 252)',
		'rgba(red(@color),green(@color),blue(@color),0.5):tinted @color',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):tinted @color',
		'rgba(#DfB787,0.74):tinted ~burlywood,tan',
	);

	#setOpt('debug', 4);

	foreach my $colorResult (@NiceNameColorTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = niceNameColor($color);

		is($result, $expect, $count++ . ") niceNameColor $color -> $expect");
	}
}

sub testUserRenameColorValid
{
	my $count = 1;
	my @UserRenameColorValidTests = (
		'#fFf:white', '#fFfFfF:white', '#fAfBfC:#fafbfc', 'white', 'red',
		'rgb(255,255,255):white', 'rgb(100%,100%,100%):white',
		'rgb( 255 , 255 , 255 ):white', 'rgb( 100% , 100% , 100% ):white',
		'hsl(0,100%,100%):white', 'hsl( 0 , 100% , 100% ):white',
		'rgba(255,255,255,1.0):white', 'rgba(100%,100%,100%,1.0):white',
		'rgba( 255 , 255 , 255 , 1.0 ):white',
		'rgba( 100% , 100% , 100% , 1.0 ):white', 'hsla(0,100%,100%,1.0):white',
		'hsla( 0 , 100% , 100% , 1.0 ):white', 'transparent',
		'rgba(255,255,255,0.0):transparent',
		'rgba(100%,100%,100%,0.0):transparent',
		'rgba( 255 , 255 , 255 , 0.0 ):transparent',
		'rgba( 100% , 100% , 100% , 0.0 ):transparent',
		'hsla(0,100%,100%,0.0):transparent',
		'hsla( 0 , 100% , 100% , 0.0 ):transparent',
		'rgba(255,255,255,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba(100%,100%,100%,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba( 255 , 255 , 255 , 0.5 ):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba( 100% , 100% , 100% , 0.5 ):rgba(red(white), green(white), blue(white), 0.5)',
		'hsla(0,100%,100%,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'hsla( 0 , 100% , 100% , 0.5 ):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba(white,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba(#fAfBfC,0.5):rgba(red(#fafbfc), green(#fafbfc), blue(#fafbfc), 0.5)',
		'rgba( white , 0.5 ):rgba(red(white), green(white), blue(white), 0.5)',
		'rgba( #fAfBfC , 0.5 ):rgba(red(#fafbfc), green(#fafbfc), blue(#fafbfc), 0.5)',
		'hsla(white,0.5):rgba(red(white), green(white), blue(white), 0.5)',
		'hsla( #fAfBfC , 0.5 ):rgba(red(#fafbfc), green(#fafbfc), blue(#fafbfc), 0.5)',
		'rgba(red(@color),green(@color),blue(@color),0.5):rgba(red(@color), green(@color), blue(@color), 0.5)',
		'rgba( red( @color ) , green( @color ) , blue( @color ) , 0.5 ):rgba(red(@color), green(@color), blue(@color), 0.5)',
	);

	setOpt('canonical', 1);
	setOpt('hash', 1);
	setOpt('names', 1);

	foreach my $colorResult (@UserRenameColorValidTests)
	{
		my ($color, $expect) = split(/:/, $colorResult);
		$expect = $expect || $color;

		my $result = userRenameColorValid($color);

		is($result, $expect, $count++ . ") userRenameColorValid $color -> $expect");
	}

	setOpt('canonical', 0);
	setOpt('hash', 0);
	setOpt('names', 0);
}

sub testColorCloseness
{
	my $count = 1;
	my @ColorClosenessTests = (
		'#fff:#ff0:57',
		'#fff:#ffa:19',
		'#123456:#123456:0',
		'#143357:#123456:2',
		'#fff:#000:100'
	);

	foreach my $closenessResult (@ColorClosenessTests)
	{
		my ($color1, $color2, $expect) = split(/:/, $closenessResult);

		my $result = int(100 * colorCloseness($color1, $color2));

		is($result, $expect, $count++ . ") colorCloseness $color1,$color2 -> $expect");
	}
}

sub testGetClosestColors
{
	my $count = 1;
	my @GetClosestColorsTests = (
		'#feffff:white/0.0022,snow/0.0161,ghostwhite/0.0209',
		'#DfB787:burlywood/0.0044,tan/0.0447',
		'#B6860c:darkgoldenrod/0.0098',
		'#123456:@variable/0.01'
	);

	#setOpt('debug', 4);

	foreach my $closenessResult (@GetClosestColorsTests)
	{
		my ($color, $expect) = split(/:/, $closenessResult);
		$expect = $expect || $color;

		my $result = join(",", map { $ARG->[0] . '/' . (int(10000 * $ARG->[1]) / 10000) } getClosestColors($color));

		is($result, $expect, $count++ . ") getClosestColors $color -> $expect");
	}
}

sub testNiceNameClosestColors
{
	my $count = 1;
	my @GetNiceNameClosestColorsTests = (
		'#feffff:~~~white,~~~snow,~~~ghostwhite',
		'#DfB787:~~~burlywood,~~tan',
		'#B6860c:~~~darkgoldenrod',
		'#123456:@variable'
	);

	#setOpt('debug', 4);

	foreach my $closenessResult (@GetNiceNameClosestColorsTests)
	{
		my ($color, $expect) = split(/:/, $closenessResult);
		$expect = $expect || $color;

		my $result = niceNameClosestColors($color);

		is($result, $expect, $count++ . ") niceNameClosestColors $color -> $expect");
	}
}

# unittestimpl

sub testSomething
{
	my $count = 0;
	my @SomethingTests = ();

	#setOpt('debug', 5);

	foreach my $somethingResult (@SomethingTests)
	{
		++$count;
		#next unless $count == 32;
		my ($color, $expect) = split(/:/, $somethingResult);

		my $result = int($color);

		is($result, $expect, $count . ") something $color -> $expect");
	}
}

# NO TEST CASE
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
