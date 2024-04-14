#!/usr/bin/env perl

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;

my $max_weight = 900;

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] [hex | red green blue] [color-name] [js-file] [css-file]

Generates a 9 point CSS color scale given a specific color value based on the 100 to $max_weight weights idea of tailwind.css.  The CSS definitions will be printed to standard output or a file.  The Javascript definitions will be printed to standard error or a file.

USE_COLOR   environment variable set to prevent maximising the color value along its vector.
hex         a single hex color value # is optional
red         the red color value 0-255
green       the green color value 0-255
blue        the blue color value 0-255
color-name  the name to give the color in the output CSS/JS. defaults to MYCOLOR
js-file     file to write javascript color definition to. Detects .js
css-file    file to write css color definition to.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

The color scale will range from the maximum possible CSS color value which intersects the color value given to one ninth of that value.  The output will be weighted from 100 to $max_weight with 100 being the darkest and $max_weight the brightest version of the color.  The given color may not fall on one of those weights but will be available in the CSS and JS output exactly.

By default the color will be maxmised along its vector but if USE_COLOR environment variable is true then the color itself will be used for weight $max_weight and all other values will be a fraction of the given color.

The color name will be lowercased for output to CSS.  A dash in the color name becomes an _ for Javascript output.

See also filter-css-colors.pl invert-css-color.pl find-css.sh all-debug-css.sh css-diagnose.sh debug-css.sh

Example:

$cmd 45 233 34 > color.css 2> color.js

  defines a Javascript color set MYCOLOR in color.js and a CSS color set mycolor in color.css

$cmd \#123 MY-COLOR mycolor.css my-color.js

  defines a Javascript color set MY_COLOR.color = '#123' in my-color.js and a CSS color set my-color-100 to my-color-$max_weight in mycolor.css

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 10;

our $the_color;
our $normalise = !$ENV{USE_COLOR};
our $has_rgb = 0;
our $has_outfiles = 0;
our $say_fh;
our $speak_fh;

usage() unless scalar(@ARGV);
if ($ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

sub check_args
{
	if (scalar(@ARGV) >= 3)
	{
		if ("$ARGV[0]$ARGV[1]$ARGV[2]" =~ m{\A[0-9]+\z}xms)
		{
			check_color_value($ARGV[0]);
			check_color_value($ARGV[1]);
			check_color_value($ARGV[2]);
			$has_rgb = 1;
		}
	} elsif ($ARGV[0] !~ m{\A\#?[0-9a-f]{3,6}\z}xms)
	{
		usage('You must provide a CSS color as a single hex value or three rgb values from 0..255.')
	}
}

sub check_color_value
{
	my ($val) = @ARG;
	usage("You must provide a CSS color value from 0..255, not $val") if $val > 255;
}

sub main
{
	check_args();
	eval
	{
		my ($red, $green, $blue);
		if ($has_rgb)
		{
			($red, $green, $blue) = ($ARGV[0], $ARGV[1], $ARGV[2]);
			$the_color = "rgb($red, $green, $blue)";
			shift @ARGV; shift @ARGV;
		}
		else
		{
			($red, $green, $blue) = hex_to_rgb_vector($ARGV[0]);
			$the_color = $ARGV[0];
		}
		shift @ARGV;
		my $name = shift @ARGV || '';
		my $js_file = shift @ARGV || '';
		my $css_file = shift @ARGV || '';

		if (!$the_color || $name =~ m{\A\d+\z}xms)
		{
			usage('You must provide a CSS color as a single hex value or three rgb values from 0..255.')
		}

		if ($name =~ m{\.}xmsi)
		{
			usage('You provided too many parameters.') if $css_file;
			$css_file = $name;
			$name = '';
		}
		usage('You provided too many parameters.') if scalar(@ARGV);

		if ($css_file =~ m{\.js}xmsi)
		{
			my $temp = $css_file;
			$css_file = $js_file;
			$js_file = $temp;
		}

		if ($js_file || $css_file)
		{
			$has_outfiles = 1;
			open($speak_fh, '>', $js_file) if $js_file;
			open($say_fh, '>', $css_file) if $css_file;
		}
		process_color($name || 'MYCOLOR', $red, $green, $blue);
	};
	if ($EVAL_ERROR)
	{
		debug("catch from main: $EVAL_ERROR", 1);
		warning($EVAL_ERROR);
	}
} # main()

sub process_color
{
	my ($name, $base_red, $base_green, $base_blue) = @ARG;
	my $jsname = $name;
	$jsname =~ s{-}{_}xmsg;

	if (!defined($base_green))
	{
		($base_red, $base_green, $base_blue) = hex_to_rgb_vector($base_red);
	}

	output_css(lc($name), $base_red, $base_green, $base_blue);
	output_js($jsname, $base_red, $base_green, $base_blue);
}

# compute maximum 255 intensity of color possible given a base color point.
# if $normalise is false then the color itself is used, which may exceed the 255 intensity
sub maximise_color
{
	my ($red, $green, $blue) = @ARG;

	if (!$normalise) {
		return ($red, $green, $blue);
	}
	my $magnitude = sqrt($red*$red + $green*$green + $blue*$blue);
	usage('You must provide a non-zero CSS color as a single hex value or three rgb values from 0..255.') if (!$magnitude);
	$red = round(255 * $red / $magnitude);
	$green = round(255 * $green / $magnitude);
	$blue = round(255 * $blue / $magnitude);
	return ($red, $green, $blue);
}

sub scale_color
{
	my ($weight, $red, $green, $blue) = @ARG;
	$red = round($red * $weight / $max_weight);
	$green = round($green * $weight / $max_weight);
	$blue = round($blue * $weight / $max_weight);
	return ($red, $green, $blue);
}

sub round
{
	my ($value) = @ARG;
	return int(0.5 + $value);
}

my @properties = qw{color background-color outline-color border-color border-top-color border-bottom-color border-left-color border-right-color };

my %prefixes = (
	color => 'text',
	'background-color' => 'bg',
	'outline-color' => 'outline',
	'border-top-color' => 'border-t',
	'border-bottom-color' => 'border-b',
	'border-left-color' => 'border-l',
	'border-right-color' => 'border-r',
	'border-color' => 'border',
);

my @pseudo = qw(hover active focus focus-visible focus-within visited);

my @weights = qw(100 200 300 400 500 600 700 800 900);

my $colon = '--';

sub output_css
{
	my ($name, $base_red, $base_green, $base_blue) = @ARG;

	my ($red, $green, $blue) = maximise_color($base_red, $base_green, $base_blue);

	# output weighted 100-900 colors for CSS color, background color, border color, etc like tailwind.
	say("/* A tailwind css like color scale for $name = $the_color */\n");
	foreach my $property (@properties)
	{
		say("\n/* === $property rules */\n");
		output_color_css($property, $prefixes{$property}, $name, $base_red, $base_green, $base_blue);
		foreach my $pseudo (@pseudo)
		{
			output_pseudo_color_css($pseudo, $property, $prefixes{$property}, $name, $base_red, $base_green, $base_blue);
		}
		say("\n");
		foreach my $weight (@weights)
		{
			my ($this_red, $this_green, $this_blue) = scale_color($weight, $red, $green, $blue);

			output_color_css($property, $prefixes{$property}, $name, $this_red, $this_green, $this_blue, $weight);
			foreach my $pseudo (@pseudo)
			{
				output_pseudo_color_css($pseudo, $property, $prefixes{$property}, $name, $this_red, $this_green, $this_blue, $weight);
			}
			say("\n");
		}
	}

}

sub output_pseudo_color_css
{
	my ($pseudo, $property, $prefix, $name, $red, $green, $blue, $suffix) = @ARG;
	$suffix = $suffix ? "-$suffix" : '';
	my $rgb = rgb_out($red, $green, $blue);
	my $hex = rgb_to_hex($red, $green, $blue);

	say(".$pseudo$colon$prefix-$name$suffix:$pseudo { $property: $hex; /* $rgb */ }\n");
}

sub output_color_css
{
	my ($property, $prefix, $name, $red, $green, $blue, $suffix) = @ARG;
	$suffix = $suffix ? "-$suffix" : '';
	my $rgb = rgb_out($red, $green, $blue);
	my $hex = rgb_to_hex($red, $green, $blue);

	say(".$prefix-$name$suffix { $property: $hex; /* $rgb */ }\n");
}

sub output_js
{
	my ($name, $base_red, $base_green, $base_blue) = @ARG;

	my ($red, $green, $blue) = maximise_color($base_red, $base_green, $base_blue);

	# output weighted 100-900 colors of JS color values.
	speak("// A tailwind css like color scale\n");
	speak("\nexport const $name = \n{\n");
	output_color_js($name, $base_red, $base_green, $base_blue);
	foreach my $weight (@weights)
	{
		my ($this_red, $this_green, $this_blue) = scale_color($weight, $red, $green, $blue);
		output_color_js($name, $this_red, $this_green, $this_blue, $weight);
	}
	speak("};\n");
}

sub output_color_js
{
	my ($name, $red, $green, $blue, $suffix) = @ARG;
	$suffix = $suffix ? $suffix : 'color';
	my $rgb = rgb_out($red, $green, $blue);
	my $hex = rgb_to_hex($red, $green, $blue);

	speak(tab(qq{\t"$suffix": "$hex", // $rgb\n}));
}

sub rgb_out
{
	my ($red, $green, $blue) = @ARG;
	return qq{rgb($red, $green, $blue)};
}

sub rgb_to_hex
{
	my ($red, $green, $blue) = @ARG;
	my $hash_color = '#' . to_hex($red) . to_hex($green) . to_hex($blue);
	$hash_color =~ s{([0-9a-f])\1([0-9a-f])\2([0-9a-f])\3}{$1$2$3}xmsi;
	return $hash_color;
}

sub to_hex
{
	my ($val) = @ARG;
	return sprintf("%02x", $val);
}

sub hex_to_rgb_vector
{
	my ($hex) = @ARG;
	$hex =~ s{\A\#?([0-9a-f])([0-9a-f])([0-9a-f])\z}{$1$1$2$2$3$3}xmsi;
	$hex =~ m{\A\#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})\z}xmsi;
	if (defined $1 && defined $2 && defined $3)
	{
		return (hex($1), hex($2), hex($3));
	}
	else
	{
		return undef;
	}
}

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
} # tab()

sub failure
{
	my ($warning) = @ARG;
	die( "ERROR: " . tab($warning) . "\n" );
} # failure()

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;
	my $message;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	if ( $DEBUG >= $level )
	{
		$message = tab($msg) . "\n";
		print $message
	}
	return $message
} # debug()

sub warning
{
	my ($warning) = @ARG;
	my $message = "WARN: " . tab($warning) . "\n";
	warn( $message );
	return $message;
} # warning()

sub say
{
	my ($message) = @ARG;
	if (!$has_outfiles)
	{
		print $message;
	}
	elsif ($say_fh)
	{
		print $say_fh $message;
	}
	return $message;
}

sub speak
{
	my ($message) = @ARG;
	if (!$has_outfiles)
	{
		print STDERR $message;
	}
	elsif ($speak_fh)
	{
		print $speak_fh $message;
	}
	return $message;
}

main();

__END__
