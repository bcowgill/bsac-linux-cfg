#!/usr/bin/env perl
# space out attributes of long HTML elements so there is one attribute per
# line where possible also put some attributes in a specific order for
# consistency i.e. id class name data-bind

# Examples
# ./pretty-elements.pl tests/pretty-elements/sample-html-elements.txt
# ./pretty-elements.pl tests/pretty-elements/sample-html-elements.txt 2>&1 | less

# find some types of tags which might have lots of attributes
# perl -ne 'sub BEGIN { $/ = undef; } s{([\ \t]*<(input|textarea|select|option|button|div|iframe|form|dl|a) \s+ [^>]+ >)}{print qq{$1\n}}xmsge; ' views/*.tt | less
# find anything and print by length of the tag
# perl -ne 'sub BEGIN { $/ = undef; } s{(<[a-zA-Z] [^>]* >)}{my $tag = $1; my $otag = $1; $tag =~ s{(\s)\s*}{\ }xmsg; print qq{@{[length($otag)]} $tag\n}}xmsge; ' views/*.tt | sort -n -r | less

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse = 1;

my $DEBUG = 1;
my $WARN_FILENAME = 0; # show filename on every warning line

$OUTPUT_AUTOFLUSH = 1 if $DEBUG;

my @AttrOrder = qw(id name type tabindex class style value method title alt data-bind action target href);
my @Elements = qw(input textarea select option button div iframe form dl a);
my $elements = join('|', @Elements);

local $INPUT_RECORD_SEPARATOR = undef;
my $q = chr(34).chr(39);  # both types of quotes
my $sol = '[\ \t]*';      # start of line whitespace
my $eol = '[\ \t]*\n';    # whitespace and end of line
my $empty = "";

my $reElement = qr{ ( $sol < ($elements) \s+ (.+?) (/?>) ) }xms;
# handle Template Toolkit
# [% IF tab_selected == 'view_campaign_heatmap' %]class="selected"[% END %] and similar
my $reTTBlock = qr{ ( \[ \% .? \s* IF .+ \% \] ) }xms;
my $reAttrib = qr{ \b ([\w|-]+) \s* = ( \d+ | ([$q]) (.*?) \3 ) }xms;
my $reAttribTrue = qr{ \b ([\w|-]+) \b }xms;

debug("reElement: $reElement");
debug("reAttrib: $reAttrib");
debug("reAttribTrue: $reAttribTrue");
debug("reTTBlock: $reTTBlock");

my %IDs = ();
my %Files = ();
my $filename = $ARGV[0];

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	$message =~ s{\t}{   }xmsg;
	return $message;
}

sub debug
{
	my ($debug) = @ARG;
	print tab($debug . "\n") if $DEBUG;
}

sub warning
{
	my ($filename, $warning) = @ARG;
	unless (exists($Files{$filename}) && !$WARN_FILENAME)
	{
		$warning = "$filename: $warning";
	}
	$Files{$filename}++;
	warn("WARN: " . tab($warning));
}

sub get_attributes
{
	my ($attributes, $all) = @ARG;
	my %Attribs = ('__TT_BLOCKS__', []);

	# First pull out any Template toolkit conditions
	$attributes =~ s{ $reTTBlock }{
		my ($condition) = ($1);
		push(@{$Attribs{'__TT_BLOCKS__'}}, $condition);
		$empty;
	}xmsge;

	$attributes =~ s{ $reAttrib }{
		my ($attr, $val) = ($1, $2);
		$val = qq{"$val"} unless $val =~ m{\A[$q]}xms;
		$Attribs{$attr} = qq{$val};
		$empty;
	}xmsge;

	$attributes =~ s{ $reAttribTrue }{
		my ($attr) = ($1);
		$Attribs{$attr} = qq{__TRUE__};
		$empty;
	}xmsge;

	$attributes =~ s{\A \s+ \z}{}xms;
	if ($attributes ne $empty)
	{
		warning($filename, "leftovers in element: [$attributes]\n   $all");
		$Attribs{'__LEFTOVERS__'} = $attributes;
	}
	return \%Attribs;
}

sub format_attr
{
	my ($attr, $value) = @ARG;
	if ($value eq '__TRUE__')
	{
		$value = $empty;
	}
	else
	{
		$value = qq{=$value};
	}
	return qq{$attr$value};
}

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

	foreach my $attr (@AttrOrder)
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
	return $DEBUG ? "FORMATTED:\n$formatted" : $formatted;
}

sub trim
{
	my ($string) = @ARG;
	$string =~ s{ \A \s+ }{}xms;
	return $string;
}

sub register_id
{
	my ($all, $id, $rhAttribs) = @ARG;
	$rhAttribs->{'id'} = $id;
	if (exists($IDs{$id}))
	{
		warning($filename, "duplicate id seen [$id]\n   [@{[trim($all)]}]\n   [@{[trim($IDs{$id}[0])]}]\n");
	}
	push(@{$IDs{$id}}, $all);
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
			register_id($all, $rhAttribs->{'name'}, $rhAttribs);
		}
		if (exists($rhAttribs->{'type'}) && $rhAttribs->{'type'} eq '"radio"')
		{
			# radio boxes must have different id/name
			$mismatch = 0;
		}
		if ($mismatch)
		{
			warning($filename, "id/name mismatch in element: [$element]\n   [$all]");
		}
	}
}

sub handle_element
{
	my ($all, $element, $attribs, $ending) = @ARG;
	my $rhAttribs = get_attributes($attribs, $all);

	handle_id_name($all, $element, $rhAttribs);

	debug(qq{\n[$all]\n   [$element] [$ending] [$attribs]});
	debug(Dumper($rhAttribs));
	return format_element($all, $element, $rhAttribs, $ending);
}

# Get the whole file and walk through the selected element types.
my $content = <>;

$content =~ s{ $reElement }{
	my ($all, $element, $attribs, $ending) = ($1, $2, $3, $4);
	print(handle_element($all, $element, $attribs, $ending) . "\n");
	"";
}xmsge;
