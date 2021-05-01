#!/usr/bin/env perl
# ./css-color-scale.pl > xxx.css 2> xxx.js

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] filename...

TODO short usage - lightweight perl script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests

This program will ...

filename    files to process instead of standard input.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

More details...

See also ...

Example:

$cmd filename...

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 1;
our $SKIP = 0;

our $TESTING = 0;
our $TEST_CASES = 10;
# prove command sets HARNESS_ACTIVE in ENV
tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

sub check_args
{
	# usage('You must provide a file matching pattern.') unless $pattern;
	# usage('You must provide a destination file name prefix.') unless $prefix;

	# failure("source [$source] must be an existing directory.") unless -d $source;
	# failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub main
{
	check_args();
	eval
	{
		process_color('mycolor', 100, 50, 25);
	};
	if ($EVAL_ERROR)
	{
		debug("catch from main: $EVAL_ERROR", 1);
		say($EVAL_ERROR);
	}
} # main()

sub process_color
{
	my ($name, $base_red, $base_green, $base_blue) = @ARG;

	output_css($name, $base_red, $base_green, $base_blue);
	output_js($name, $base_red, $base_green, $base_blue);
}

# compute maximum intensity of color possible given a base color point.
sub maximise_color
{
	my ($red, $green, $blue) = @ARG;

	my $magnitude = sqrt($red*$red + $green*$green + $blue*$blue);
	$red = round(255 * $red / $magnitude);
	$green = round(255 * $green / $magnitude);
	$blue = round(255 * $blue / $magnitude);
	return ($red, $green, $blue);
}

sub scale_color
{
	my ($weight, $red, $green, $blue) = @ARG;
	$red = round($red * $weight / 900);
	$green = round($green * $weight / 900);
	$blue = round($blue * $weight / 900);
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

	say(".$pseudo$colon$prefix-$name$suffix:$pseudo { $property: @{[rgb_out($red, $green, $blue)]}; }\n");
}

sub output_color_css
{
	my ($property, $prefix, $name, $red, $green, $blue, $suffix) = @ARG;
	$suffix = $suffix ? "-$suffix" : '';

	say(".$prefix-$name$suffix { $property: @{[rgb_out($red, $green, $blue)]}; }\n");
}

sub output_js
{
	my ($name, $base_red, $base_green, $base_blue) = @ARG;

	my ($red, $green, $blue) = maximise_color($base_red, $base_green, $base_blue);

	# output weighted 100-900 colors of JS color values.
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

	speak(tab(qq{\t"$suffix": "@{[rgb_out($red, $green, $blue)]}",\n}));
}

sub rgb_out
{
	my ($red, $green, $blue) = @ARG;
	return qq{rgb($red, $green, $blue)};
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
		if ($TESTING)
		{
			diag(qq{DEBUG: $message});
		}
		else
		{
			print $message
		}
	}
	return $message
} # debug()

sub warning
{
	my ($warning) = @ARG;
	my $message = "WARN: " . tab($warning) . "\n";
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		warn( $message );
	}
	return $message;
} # warning()

sub say
{
	my ($message) = @ARG;
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		print $message;
	}
	return $message;
}

sub speak
{
	my ($message) = @ARG;
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		print STDERR $message;
	}
	return $message;
}

main();

#===========================================================================
# unit test functions
#===========================================================================

sub test_say
{
	my ($expect, $message) = @ARG;
	my $result = say($message);
	is($result, $expect, "say: [$message] == [$expect]");
}

sub test_tab
{
	my ($expect, $message) = @ARG;

	my $result = tab($message);
	is($result, $expect, "tab: [$message] == [$expect]");
}

sub test_warning
{
	my ($expect, $message) = @ARG;
	my $result = warning($message);
	is($result, $expect, "warning: [$message] == [$expect]");
}

sub test_debug
{
	my ($expect, $message, $level) = @ARG;
	my $result = debug($message, $level);
	is($result, $expect, "debug: [$message, $level] == [@{[$expect || 'undef']}]");
}

sub test_failure
{
	my ($expect, $message) = @ARG;

	my $result;
	eval {
		failure($message);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}
	is($result, $expect, "failure: [$message] == [$expect]");
} # test_failure()

#===========================================================================
# unit test suite helper functions
#===========================================================================

# setup / teardown and other helpers specific to this test suite
# see auto-rename.pl for setup of lock dirs etc.

#===========================================================================
# unit test library functions
#===========================================================================

# see auto-rename.pl for a wide variety of test assertions for files, directories, etc.

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	$TESTING = 1;

	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_say("Hello, there", "Hello, there") unless $SKIP;
	test_tab("         Hello", "\t\t\tHello") unless $SKIP;
	test_warning("WARN: WARNING, OH MY!\n", "WARNING, OH MY!") unless $SKIP;
	test_debug(undef, "DEBUG, OH MY!", 10000) unless $SKIP;
	test_debug("DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000) unless $SKIP;
	test_failure("ERROR: FAILURE, OH MY!\n", "FAILURE, OH MY!") unless $SKIP;
	exit 0;
}

__END__
__DATA__
I am the data.
