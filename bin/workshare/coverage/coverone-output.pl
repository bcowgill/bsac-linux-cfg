#!/usr/bin/env perl
# coverone-output.pl generate coverage index page from csv output

use English qw(-no_match_vars);
use strict;
use warnings;
use File::Slurp qw(:std);
use Data::Dumper;

my $DEBUG = 0;
my $template_file = $0;
$template_file =~ s{ / [^/]+ \z }{/coverage-index.html}xmsg;
my $rTemplate = read_file($template_file, scalar_ref => 1);
my $row_template = pull_row_template($template_file, $rTemplate);
print "Template: $template_file\n$row_template" if $DEBUG;

my $summarize = 0;
my @Headings = ();
my $headings;
my @Rows = ();
my %Worst = (
);
my %Mapping = (
	# row only mapping
	WORST => 'Worst',
	STATEMENTS => 'Statements',
	BRANCHES => 'Branches',
	FUNCTIONS => 'Functions',
    LINES => 'Lines',
	FILE => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'FILE', 'Full Path')
	},
	FILE_NICE => sub {
		my ($rhValues) = @ARG;
		return nice_name(
			get($rhValues, 'FILE_NICE', 'Full Path'),
			get($rhValues, 'FILE_NICE', 'Test Plan'))
	},
	FILE_URL => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'FILE_URL', 'File') . '.html'
	},
	TEST_PLAN => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'TEST_PLAN', 'Test Plan')
	},
	ST_DETAIL => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'ST_DETAIL', 'Statements Detail')
	},
	BR_DETAIL => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'BR_DETAIL', 'Branches Detail')
	},
	FN_DETAIL => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'FN_DETAIL', 'Functions Detail')
	},
	LN_DETAIL => sub {
		my ($rhValues) = @ARG;
		return get($rhValues, 'LN_DETAIL', 'Lines Detail')
	},
	WR_REMAINDER => sub {
		my ($rhValues) = @ARG;
		return remainder(get($rhValues, 'WR_REMAINDER', 'Worst'))
    },
	ST_REMAINDER => sub {
		my ($rhValues) = @ARG;
		return remainder(get($rhValues, 'ST_REMAINDER', 'Statements'))
    },
	BR_REMAINDER => sub {
		my ($rhValues) = @ARG;
		return remainder(get($rhValues, 'BR_REMAINDER', 'Branches'))
    },
	FN_REMAINDER => sub {
		my ($rhValues) = @ARG;
		return remainder(get($rhValues, 'FN_REMAINDER', 'Functions'))
    },
	LN_REMAINDER => sub {
		my ($rhValues) = @ARG;
		return remainder(get($rhValues, 'LN_REMAINDER', 'Lines'))
    },
	ST_LINES => sub {
		my ($rhValues) = @ARG;
		return lines(get($rhValues, 'ST_LINES', 'Statements Detail'))
	},
	BR_LINES => sub {
		my ($rhValues) = @ARG;
		return lines(get($rhValues, 'BR_LINES', 'Branches Detail'))
	},
	FN_LINES => sub {
		my ($rhValues) = @ARG;
		return lines(get($rhValues, 'FN_LINES', 'Functions Detail'))
	},
	LN_LINES => sub {
		my ($rhValues) = @ARG;
		return lines(get($rhValues, 'LN_LINES', 'Lines Detail'))
	},
	WR_HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'WR_HML', 'Worst'))
    },
	ST_HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'ST_HML', 'Statements'))
    },
	BR_HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'BR_HML', 'Branches'))
    },
	FN_HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'FN_HML', 'Functions'))
    },
	LN_HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'LN_HML', 'Lines'))
    },
	HML => sub {
		my ($rhValues) = @ARG;
		return hml(get($rhValues, 'HML', 'Worst'))
	},

	# page wide mapping
	WORST_STATEMENTS => sub () {
		my ($rhValues) = @ARG;
		return worst($rhValues, 'Statements')
	},
	WORST_BRANCHES => sub () {
		my ($rhValues) = @ARG;
		return worst($rhValues, 'Branches')
	},
	WORST_FUNCTIONS => sub () {
		my ($rhValues) = @ARG;
		return worst($rhValues, 'Functions')
	},
	WORST_LINES => sub () {
		my ($rhValues) = @ARG;
		return worst($rhValues, 'Lines')
	},
	STATUS_LINE_HML => sub {
		my ($rhValues) = @ARG;
		return hml(worst($rhValues, 'Statements'), 'STATUS_LINE_HML')
    },
);
my @MapOrder = sort by_field keys(%Mapping);
my $rhLastFields;

print Dumper \@MapOrder if $DEBUG;

while (my $csv_line = <>) {
	print "$headings\n" if $DEBUG && $headings;
	print "$csv_line" if $DEBUG;
	next if $csv_line =~ m{\A Unknown}xms;
	chomp($csv_line);
	if (scalar(@Headings)) {
		my %Fields = get_fields($csv_line);
		print Dumper \%Fields if $DEBUG;
		my $template = $row_template;
		print Dumper \%Fields if $DEBUG;
		push(@Rows, substitute_fields($template, \%Fields));
		$rhLastFields = \%Fields;
    }
	else {
		@Headings = split(/,/, $csv_line);
		$headings = join(',', @Headings);
		print Dumper \@Headings if $DEBUG;
    }
}

print "prepare summary\n" if $DEBUG;
print Dumper \%Worst if $DEBUG;
$summarize = 1;
my $rows = join("\n", @Rows);
process_mapping($rhLastFields);
$rhLastFields->{ROWS} = $rows;
print substitute_fields($$rTemplate, $rhLastFields);

sub pull_row_template {
	my ($template_file, $rTemplate) = @ARG;

	my $row_template;
	$$rTemplate =~ s{
		<!-- \s+ Template \s+ for \s+ a \s+ row \s+ -->
		(.+)
		<!-- \s+ /Template \s+ for \s+ a \s+ row \s+ -->
	}{
		$row_template = $1;
		"\%ROWS%"
	}xmsge;

	die "$template_file: unable to find <!-- Template for a row --> markers in template" unless $row_template;
	return $row_template;
}

sub get_fields {
	my ($csv_line) = @ARG;
	my $idx = 0;
	my %Fields = map {
		$ARG =~ s{\%\z}{}xmsg;
		($Headings[$idx++], $ARG)
	} split(/,/, $csv_line);

	process_mapping(\%Fields);
	return %Fields;
}

sub process_mapping {
	my ($rhFields) = @ARG;

	foreach my $key (@MapOrder) {
		my $map_to = $Mapping{$key};
		if (ref($map_to)) {
			$rhFields->{$key} = $map_to->($rhFields);
		}
		else {
			$rhFields->{$key} = get($rhFields, $key, $map_to)
		}
	}
	return $rhFields;
}

sub substitute_fields {
	my ($template, $rhFields) = @ARG;
	$template =~ s{
		\%([_A-Z0-9]+)\%
	}{
		put($rhFields, $1)
	}xmsge;
	return $template
}

sub put {
	my ($rhFields, $key) = @ARG;
	my $value = $rhFields->{$key} || '';
	die "cannot substitute field $key into template" unless (exists($rhFields->{$key}));
	return $value
}

sub get {
	my ($rhFields, $key, $map_to) = @ARG;
	die "cannot map $key <= CSV field $map_to" unless (exists($rhFields->{$map_to}));
	return $rhFields->{$map_to}
}

sub lines {
	my ($value) = @ARG;
	return (split(m{/}, $value))[0]
}

sub remainder {
	my ($value) = @ARG;
	return 100 - $value
}

sub hml {
	my ($value, $which) = @ARG;
	print "hml($which)\n" if $DEBUG && $which;
	$value ||= 0;
	return 'high' if ($value >= 80);
	return 'low' if ($value < 50);
	return 'medium';
}

sub nice_name {
	my ($full_name, $test_plan) = @ARG;
	$test_plan =~ s{\A .+ / ([^/]+) \z}{$1}xmsg;
	$full_name =~ s{
		\A (.+) / ([^/]+) \z
	}{<b>$2</b> $1/ ($test_plan)}xmsg;
	return $full_name;
}

sub worst {
	my ($rhValues, $type) = @ARG;
	my $key = 'WORST_' . uc($type);
	if ($summarize) {
		print "summary worst($type) $key\n" if $DEBUG;
		print Dumper \%Worst if $DEBUG;
		return get(\%Worst, $key, $key)
	}
	else {
		print "worst($type) $key\n" if $DEBUG;
		my $worst = $Worst{$key} || 100;
		my $current = get($rhValues, $key, $type);
		if ($current < $worst) {
			$Worst{$key} = $current
		}
		else {
			$Worst{$key} = $worst
		}
		print "ret $Worst{$key}\n" if $DEBUG;
		return $Worst{$key}
	}
}

sub by_field {
	return field_sort($a) cmp field_sort($b)
}

sub field_sort {
	my ($field) = @ARG;
	$field = "Z$field" if $field =~ m{ \A WORST_ }xms;
	$field = "ZZ$field" if $field eq 'STATUS_LINE_HML';
	return $field;
}

__END__
