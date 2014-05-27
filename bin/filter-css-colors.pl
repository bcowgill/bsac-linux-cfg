#!/usr/bin/env perl

=head1 NAME

filter-css-colors.pl - Find all CSS color declarations in files

=head1 TODO

--foreground=xxxx substitute a color for all foreground colors
--background=xxxx you get color: #fff /* original color */;
--undo undo a foreground/background change

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

perl.pl [options] [@options-file ...] [file ...]

 Options:
	--color-only     negatable. only show the color values, not the entire line.
	--reverse        negatable. show all lines not matching a CSS color declaration.
	--remap          negatable. remap all colors to names in place where possible.
	--names          negatable. convert colors to standard names where possible
	--canonical      negatable. convert colors to canonical form i.e. #fff -> #ffffff
	--rgb            negatable. convert colors to rgb() form
	--valid-only     do not perform remappings which are invalid CSS
	--inplace        specify to modify files in place creating a backup first
	--foreground     specify a color value to use for all foreground colors.
	--background     specify a color value to use for all background colors.
	--echo           negatable. display original line when performing replacements
	--version        display program version and exit
	--debug          incremental. display debugging info.
	--help -?        brief help message and exit
	--man            full help message and exit

=head1 OPTIONS

=over 8

=item B<--color-only> or B<--nocolor-only>

 Only display the CSS color values used. Useful to identify all unique colors used.

=item B<--reverse> or B<--noreverse>

 Only display lines that do not contain CSS color declarations.

=item B<--remap> or B<--noremap>

 Remap colors to canonical values and/or names in place where possible. May not produce valid CSS as for example rgba(0,0,0,0.5) becomes rgba(black,0.5)

 You should specify --names or --canonical as well to have any effect.

=item B<--names> or B<--nonames>

 Show colors as standard names where possible. i.e. #fff becomes white.
 Implies --canonical as well.
 Implies --remap as well.

=item B<--canonical> or B<--nocanonical>

 Show colors in canonical form i.e. #fff becomes '#ffffff'.
 Implies --remap as well.

=item B<--rgb>  or B<--norgb>

 Show colors in rgb() form i.e. #fff becomes rgb(255,255,255).
 Implies --canonical as well. Cannot use --names with --rgb.

=item B<--valid-only>

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

 TODO template/perl.pl --length=32 --file this.txt filename.inline --in - --out - --ratio=43.345 --debug --debug --debug --name=fred --name=barney --map key=value --map this=that -m short=value --hex=0x3c7e --width -- --also-a-file -

=cut

use strict;
use warnings;
use English -no_match_vars;
use Getopt::ArgvFile defult => 1; # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;
#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;

use File::Copy qw(cp); # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use Fatal qw(cp);

our $VERSION = 0.1; # shown by --version option

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			'valid-only' => 0,
			'' => 0,      # indicates standard in/out as - on command line
			'debug' => 0,   # output debug info
			'man' => 0,     # show full help page
		},
		raFile => [],
	},
	rhGetopt => {
		result => undef,
		raErrors => [],
		raConfig => [
			"bundling",     # bundle single char options ie ps -aux
			"auto_version", # supplies --version option
			"auto_help",    # supplies --help -? options to show usage in POD SYNOPSIS
#			"debug",       # debug the argument processing
		],
		raOpts => [
			"color-only!",
			"reverse!",
			"remap!",
			"names!",
			"canonical!",
			"rgb!",
			"valid-only",
			"inplace|i:s",
			"foreground|fg:s",
			"background|bg:s",
			"echo!",
			"debug+",
			"man",

			"",           # empty string allows - to signify standard in/out as a file
		],
		raMandatory => [], # additional mandatory parameters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},
	'raColorNames' => ['transparent'],
	'rhColorNamesMap' => {},
	'regex' => {
		'data'        => qr{ \A \s* (\w+) \s+ ( \#[0-9a-f]{6} ) \s+ ( \d+,\d+,\d+ ) }xmsi,
		'line'        => '', # populated in setup()
		'transparent' => qr{ (rgb|hsl) a \( [^\)]+? , \s* [0\.]+ \s* \) }xmsi,
		'opaque'      => qr{ (rgb|hsl) a ( \( [^\)]+ ) , \s* 1(\.0*)? \s* \) }xmsi,
		'rgba'        => qr{ \A rgba\( \s* ( \d+ \%? \s* , \s* \d+ \%? \s* , \s* \d+ \%? ) ( \s* , \s* [^\)]+ ) \) }xms,
		'hsl'         => qr{ hsl \( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% \s* \) }xms,
		'hsla'        => qr{ \A hsla\( \s* (\d+) \s* , \s* (\d+) \% \s* , \s* (\d+) \% ( \s* , \s* [^\)]+ ) \) }xms,
	},
);

getOptions();

sub main
{
	my ($rhOpt, $raFiles, $use_stdio) = @ARG;
	debug("Var: " . Dumper(\%Var), 2);
	debug("main() rhOpt: " . Dumper($rhOpt) . "\nraFiles: " . Dumper($raFiles) . "\nuse_stdio: $use_stdio\n", 2);

	$use_stdio = 1 unless scalar(@$raFiles);
	if ($use_stdio)
	{
		processStdio($rhOpt);
	}

	processFiles($raFiles, $rhOpt) if scalar(@$raFiles);
}

sub setup
{
	my ($rhOpt) = @ARG;

	# read from __DATA__ below to get names of hex color values
	while (my $line = <DATA>)
	{
		if ($line =~ m{ $Var{'regex'}{'data'} }xmsi)
		{
			push(@{$Var{'raColorNames'}}, $1);
			$Var{'rhColorNamesMap'}{lc($2)} = $1;
			$Var{'rhColorNamesMap'}{"rgb($3)"} = $1;
			$Var{'rhColorNamesMap'}{$3} = $1;
		}
	}
	debug("ColorNameMap " . Dumper($Var{'rhColorNamesMap'}), 2);
	my $colors = join('|', @{$Var{'raColorNames'}});
	debug("colors regex: $colors\n", 2);
	$Var{'regex'}{'line'} = qr{ ( \#[0-9a-f]{3,6}\b | (rgb|hsl)a?\([^\)]+\) | \b($colors)\b ) }xmsi;
}

sub processStdio
{
	my ($rhOpt) = @ARG;
	debug("processStdio()\n");
	my $raContent = read_file(\*STDIN, array_ref => 1);
	doReplacement($raContent);
	print join("", @$raContent);
}

sub processFiles
{
	my ($raFiles, $rhOpt) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		if (exists($rhOpt->{'inplace'}))
		{
			editFileInPlace($fileName, $rhOpt->{'inplace'}, $rhOpt);
		}
		else
		{
			processFile($fileName, $rhOpt);
		}
	}
}

sub processFile
{
	my ($fileName, $rhOpt) = @ARG;
	debug("processFile($fileName)\n");

	# example slurp in the file and show something
	my $raContent = read_file($fileName, array_ref => 1);
	doReplacement($raContent);
	print join("", @$raContent);
}

sub doReplacement
{
	my ($raContent) = @ARG;
	foreach my $line (@$raContent)
	{
		$line = doReplaceLine($line);
	}
	return $raContent;
}

sub doReplaceLine
{
	my ($line) = @ARG;
	my $match = 0;
	my @Lines = ();
	# unfortunately the color name matching could match comments, or class/id names in the CSS
	# and can't check for a : before because rule could be split across two lines
	# maybe using negative lookbefore for # - . could handle the color names would also have to strip comments first
	$match = ($line =~ $Var{'regex'}{'line'});
	$match = $Var{'rhArg'}{'rhOpt'}{'reverse'} ? !$match : $match;
	if ($match)
	{
		$line =~ s{ \A \s+ }{}xms;
		if ($Var{'rhArg'}{'rhOpt'}{'color-only'} && !$Var{'rhArg'}{'rhOpt'}{'reverse'})
		{
			$line =~ tr[A-Z][a-z];
			$line =~ s{$Var{'regex'}{'line'}}{ push(@Lines, remap($1) . "\n"); "" }ge;
		}
		else
		{
			if ($Var{'rhArg'}{'rhOpt'}{'echo'})
			{
				push(@Lines, "\nwas: $line     ");
			}
			push(@Lines, remap($line));
		}
	}
	return join("", @Lines);
}

sub editFileInPlace
{
	my ($fileName, $suffix, $rhOpt) = @ARG;
	my $fileNameBackup = "$fileName$suffix";
	debug("editFileInPlace($fileName) backup to $fileNameBackup\n");

	unless ($fileName eq $fileNameBackup)
	{
		cp($fileName, $fileNameBackup);
	}
	edit_file_lines { $ARG = doReplaceLine($ARG) } $fileName;
}


# remap color values in place, where possible
# this may not produce valid CSS output.
# for example rgba(0,0,0,0.5) can become rgba(black,0.5)
sub remap
{
	my ($line) = @ARG;
	if ($Var{'rhArg'}{'rhOpt'}{'remap'})
	{
		$line =~ s{$Var{'regex'}{'line'}}{ names(rgb(canonical($1))) }ge;
	}
	return $line;
}

# convert #rgb color to #rrggbb so output can be compared against uniqueness
sub canonical
{
	my ($color) = @ARG;
	if ($Var{'rhArg'}{'rhOpt'}{'canonical'})
	{
		$color =~ s{ \# ([0-9a-f]{3}) \b }{
			'#' . (substr($1,0,1) x 2) .
			(substr($1,1,1) x 2) .
			(substr($1,2,1) x 2)
		}xmsgie;
	}
	return $color;
}

# convert color value to rgb(R,G,B) format
sub rgb
{
	my ($color) = @ARG;
	$DB::single = 1;  # MUSTDO REMOVE THIS
	if ($Var{'rhArg'}{'rhOpt'}{'rgb'})
	{
		$color =~ s{ \# ([0-9a-f]{2}) ([0-9a-f]{2}) ([0-9a-f]{2}) \b }{ "rgb(" . hex($1) . ", " . hex($2) . ", " . hex($3) . ")" }xmsgie;
	}
	return $color;
}

# MUSTDO implement foreground/background

# convert color value to color name if $USE_NAMES set
# color could be #rrggbb or r,g,b triplet or r%,g%,b%
# or rgb(...) rgba(...) hsl(...) hsla(...)
# returns name of the color or the original color value
sub names
{
	my ($color) = @ARG;
	if ($Var{'rhArg'}{'rhOpt'}{'names'})
	{
		# alpha = 0 is transparent
		$color =~ s{ $Var{'regex'}{'transparent'} }{transparent}xmsg;
		# alpha = 1 is opaque convert to hsl or rgb
		$color =~ s{ $Var{'regex'}{'opaque'} }{$1$2)}xmsg;

		$color = $Var{'rhColorNamesMap'}{lc(trim(rgbval($color)))} || $color;
		if (!$Var{'rhArg'}{'rhOpt'}{'valid-only'} && $color =~ m{ $Var{'regex'}{'rgba'} }xms)
		{
			if (exists $Var{'rhColorNamesMap'}{trim(rgbval($1))})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{trim(rgbval($1))}$2)";
			}
		}
		if (!$Var{'rhArg'}{'rhOpt'}{'valid-only'} && $color =~ m{ $Var{'regex'}{'hsla'} }xms)
		{
			if (exists $Var{'rhColorNamesMap'}{trim(hsl_to_rgb($1, $2, $3))})
			{
				$color = "rgba($Var{'rhColorNamesMap'}{trim(hsl_to_rgb($1, $2, $3))}$4)";
			}
		}
	}
	return $color;
}

# get rgb value from percentage or hsl
# 100%,100%,100% becomes 255,255,255
# hsl(h,s%,l%) becomes rgb(r,g,b)
sub rgbval
{
	my ($vals) = @ARG;
	$vals =~ s{ $Var{'regex'}{'hsl'} }{ "rgb(" . hsl_to_rgb($1, $2, $3) . ")"}xmse;
	$vals =~ s{ (\d+) % }{ int(0.5 + (255 * $1 / 100)) }xmsge;
	return $vals;
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
	return "$r,$g,$b"
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
	my ($raErrors, $rhOpt, $raFiles, $use_stdio) = @ARG;
	checkMandatoryOptions($raErrors, $rhOpt, $Var{rhGetopt}{raMandatory});

	# Check additional parameter dependencies and push onto error array
	if (exists($rhOpt->{'inplace'}))
	{
		push(@$raErrors, "You cannot specify standard input when using the --inplace option") if $use_stdio;
		push(@$raErrors, "You must supply files to process when using the --inplace option.") unless scalar(@$raFiles);
	}
	if ($rhOpt->{'color-only'})
	{
		push(@$raErrors, "You cannot specify --foreground when using the --color-only option") if exists($rhOpt->{'foreground'});
		push(@$raErrors, "You cannot specify --background when using the --color-only option") if exists($rhOpt->{'background'});
	}

	# Force some flags when others turned on
	$rhOpt->{'canonical'} = 1 if ($rhOpt->{'names'} || $rhOpt->{'rgb'});
	$rhOpt->{'remap'} = 1 if ($rhOpt->{'names'} || $rhOpt->{'canonical'});

	if ($rhOpt->{'rgb'})
	{
		push(@$raErrors, "You cannot specify --names when using the --rgb option") if $rhOpt->{'names'};
	}

	if (scalar(@$raErrors))
	{
		usage(join("\n", @$raErrors));
	}
}

sub checkMandatoryOptions
{
	my ($raErrors, $rhOpt, $raMandatory) = @ARG;

	$raMandatory = $raMandatory || [];
	foreach my $option (@{$Var{rhGetopt}{raOpts}})
	{
		# Getopt option has = sign for mandatory options
		my $optName = undef;
		$optName = $1 if $option =~ m{\A (\w+)}xms;
		if ($option =~ m{\A (\w+) .* =}xms
			|| ($optName && grep { $ARG eq $optName } @{$raMandatory}))
		{
			my $error = 0;

			# Work out what type of parameter it might be
			my $type = "value";
			$type = 'number value' if $option =~ m{=f}xms;
			$type = 'integer value' if $option =~ m{=i}xms;
			$type = 'incremental value' if $option =~ m{\+}xms;
			$type = 'negatable value' if $option =~ m{\!}xms;
			$type = 'decimal/oct/hex/binary value' if $option =~ m{=o}xms;
			$type = 'string value' if $option =~ m{=s}xms;
			$type =~ s{value}{multi-value}xms if $option =~ m{\@}xms;
			$type =~ s{value}{key/value pair}xms if $option =~ m{\%}xms;

			if (exists($rhOpt->{$optName}))
			{
				my $ref = ref($rhOpt->{$optName});
				if ('ARRAY' eq $ref && 0 == scalar(@{$rhOpt->{$optName}}))
				{
					$error = 1;
					# type might not be configured but we know it now
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ('HASH' eq $ref && 0 == scalar(keys(%{$rhOpt->{$optName}})))
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
			push(@$raErrors, "--$optName $type is a mandatory parameter.") if $error;
		}
	}
	return $raErrors;
}

# Perform command line option processing and call main function.
sub getOptions
{
	$Var{rhGetopt}{roParser}->configure(@{$Var{rhGetopt}{raConfig}});
	$Var{rhGetopt}{result} = 	$Var{rhGetopt}{roParser}->getoptions(
		$Var{rhArg}{rhOpt},
		@{$Var{rhGetopt}{raOpts}}
	);
	if ($Var{rhGetopt}{result})
	{
		manual() if $Var{rhArg}{rhOpt}{man};
		$Var{rhArg}{raFile} = \@ARGV;
		checkOptions(
			$Var{rhGetopt}{raErrors},
			$Var{rhArg}{rhOpt},
			$Var{rhArg}{raFile},
			$Var{rhArg}{rhOpt}{''}
		);
		setup($Var{rhArg}{rhOpt});
		main($Var{rhArg}{rhOpt}, $Var{rhArg}{raFile}, $Var{rhArg}{rhOpt}{''});
	}
	else
	{
		# Here if unknown option provided
		usage();
	}
}

sub debug
{
	my ($msg, $level) = @ARG;
	$level ||= 1;
#	print "debug @{[substr($msg,0,10)]} debug: $Var{'rhArg'}{'rhOpt'}{'debug'} level: $level\n";
	print $msg if ($Var{'rhArg'}{'rhOpt'}{'debug'} >= $level);
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
	$DB::single = 1; # MUSTDO REMOVE THIS

	pod2usage(
		-exitval => 0,
		-verbose => 2,
	);
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
