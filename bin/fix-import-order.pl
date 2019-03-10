#!/usr/bin/env perl
# Reorder Javascript imports into a nice triangle.
# Absolute imports first in ascending line length.
# Followed by relative imports in descending line length.

use strict;
use warnings;

use English qw(-no_match_vars);
use Carp qw(croak);
use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use autodie qw(open cp);

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

our $TEST_CASES = 25;
our $TRACE = 0;

tests() if scalar(@ARGV) && $ARGV[0] eq '--test';
usage() if !scalar(@ARGV) || $ARGV[0] eq '--help';

print "HEREIAM1 @ARGV\n" if $TRACE;

main();

#===========================================================================
# application functions
#===========================================================================

sub usage
{
	my ($reason) = @ARG;

	print STDERR "$reason\n\n" if $reason;

	print << "USAGE";
$0 javascript-file [...]

This script reorders import references in a Javascript source file into a nice triangle.  Absolute imports first in ascending line length.  Followed by relative imports in descending line length.

It keeps an eslint-disable-next-line or other comment directly above the import that follows it.

A sorted import section might look like this:

	import React from 'react';
	import PropTypes from 'prop-types';
	// eslint-disable-line no-extraneous-dependencies
	import Frog from 'components/frogger';
	import log from '../utils/log';
	import fire from './fire';

USAGE

	exit($reason ? 1 : 0);
}

sub main
{
	my @Files = @ARGV;

	foreach my $file (@Files)
	{
		print "main $file\n" if $TRACE;
		fix_imports_order($file);
	}
}

sub fix_imports_order
{
	my ($filename) = @ARG;

	print "\n$filename: reordering imports.\n";
	edit_file_in_place($filename, '.bak');
}

sub edit_file_in_place
{
	my ( $fileName, $suffix ) = @ARG;
	my $fileNameBackup = "$fileName$suffix";

	print "edit_file_in_place $fileName, $suffix\n" if $TRACE;
	unless ($fileName eq $fileNameBackup)
	{
		cp( $fileName, $fileNameBackup );
	}
	edit_file { doReplacement( \$ARG ) } $fileName;
}

sub doReplacement
{
	my ( $rContent ) = @ARG;

	print "doReplacement $$rContent\n" if $TRACE;
	my $output = process_input($$rContent);
   $$rContent = $output;
	return $output;
}

sub start_state
{
	return {
		state => 'BEFORE',
		output => [],
		imports => [],
		lines => [],
		token => '',
		found => '',
		top => '',
		'import' => undef,
	};
}

sub parse_from_top
{
	my ($rhState, $top) = @ARG;
	$rhState->{'import'} = undef;
	if ($top =~ s{\A (\s* (\n|\z))}{}xms)
	{
		$rhState->{token} = 'BLANKS';
		$rhState->{found} = $1;
		$rhState->{top} = $top;
	}
	elsif ($top =~ s{\A (\s* /\* (.+?) \*/\s*(\n|\z))}{}xms)
	{
		$rhState->{token} = 'COMMENT_BLOCK';
		$rhState->{found} = $1;
		$rhState->{top} = $top;
	}
	elsif ($top =~ s{
		\A (
			(\s* //)? \s* import \s+ (.+? from \s*)? (['"]) (.+?) \4 [^\n]* (\n|\z)
		)
	}{}xms)
	{
		my $found = $1;
		my $module = $5;

		$rhState->{token} = 'IMPORT';
		$rhState->{found} = $found;

		# get longest length from the lines that make up the import
		my $raLines = [map { "$ARG\n" } split(/\n/, $found)];
		my $length = 0;
		foreach my $line (@$raLines)
		{
			my $ch = "$line";
			chomp($ch);
			my $len = length($ch);
			if ($ch =~ m{\A \s* (// ?)}xms)
			{
				$len -= length($1);
			}
			if ($ch =~ m{(['"]) .+? \1 \s* ;? ([^\n]*) (\n|\z)}xms)
			{
				$len -= length($2);
			}
			$length = $len > $length ? $len : $length;
		}
		unless (substr($found, -1) eq "\n")
		{
			# being careful to omit newline on last line if needed
			chomp($raLines->[-1]);
		}

		# construct import object for later sorting
		$rhState->{'import'} = {
			length => $length,
			type => $module =~ m{\A\.}xms ? 'RELATIVE' : 'PACKAGE',
			lines => $raLines,
		};
		$rhState->{top} = $top;

		# attach the queued comment to the import line if needed
		if (scalar(@{$rhState->{lines}}))
		{
			unshift($raLines, @{$rhState->{lines}});
			$rhState->{lines} = [];
		}
	}
	elsif ($top =~ s{\A (\s* // ([^\n]+) (\n|\z))}{}xms)
	{
		$rhState->{token} = 'COMMENT_LINE';
		$rhState->{found} = $1;
		$rhState->{top} = $top;
	}
	elsif ($top =~ s{\A ([^\n]+(\n|\z))}{}xms) {
		$rhState->{token} = 'CODE';
		$rhState->{found} = $1;
		$rhState->{top} = $top;
	}
	else {
		$rhState->{token} = 'UNKNOWN';
		$rhState->{found} = '';
		die "Unknown token at ==> $rhState->{top}\n";
	}

	return $rhState;
}

sub state_change
{
	my ($rhState) = @ARG;
	my $state = $rhState->{state};
	my $token = $rhState->{token};
	my $found = $rhState->{found};

	# token: BLANKS, COMMENT_BLOCK, COMMENT_LINE, IMPORT, CODE
	my $raFlush;
	if ($state eq 'BEFORE')
	{
		if ($token eq 'IMPORT')
		{
			# first import line, store it and change state to IMPORTS
			$rhState->{state} = 'IMPORTS';
			$rhState->{imports} = [$rhState->{import}];
			$rhState->{import} = undef;
		}
		elsif ($token eq 'COMMENT_LINE')
		{
			# a comment line, flush what we have and cache this line
			$raFlush = $rhState->{lines};
			$rhState->{lines} = [$found];
		}
		elsif ($token eq 'BLANKS')
		{
			# some blanks, flush what we have and keep looking
			$raFlush = $rhState->{lines};
			push(@$raFlush, $found);
			$rhState->{lines} = [];
		}
		else
		{
			# anything else flush what we have
			$raFlush = $rhState->{lines};
			push(@$raFlush, $found);
			$rhState->{lines} = [];
		}
	}
	elsif ($state eq 'IMPORTS')
	{
		if ($token eq 'IMPORT')
		{
			# another import line, keep storing them
			push(@{$rhState->{imports}}, $rhState->{import});
			$rhState->{import} = undef;
		}
		elsif ($token eq 'COMMENT_LINE')
		{
			# a comment line, save it or end of imports
			if (scalar(@{$rhState->{lines}}))
			{
				$raFlush = $rhState->{lines};
				push(@$raFlush, $found);
				$rhState->{lines} = [];
				$rhState->{state} = 'AFTER';
			}
			else
			{
				$rhState->{lines} = [$found];
			}
		}
		else
		{
			# anything else is the end of import section
			$raFlush = $rhState->{lines};
			push(@$raFlush, $found);
			$rhState->{lines} = [];
			$rhState->{state} = 'AFTER';
		}
	}
	if ($rhState->{state} eq 'AFTER')
	{
		print "AFTER rhState: " . Dumper($rhState) if $TRACE > 1;
		# order the imports and add to output
		my $raImports = order_imports($rhState->{imports});
		print "raImports: " . Dumper($raImports) if $TRACE > 1;
		push(@{$rhState->{output}}, @$raImports);
		$rhState->{found} = '';
		$rhState->{imports} = [];
	}
	if ($raFlush && scalar(@$raFlush))
	{
		push(@{$rhState->{output}}, @$raFlush);
	}
	if ($rhState->{state} eq 'AFTER')
	{
		push(@{$rhState->{output}}, $rhState->{top});
		$rhState->{top} = '';
	}
	return $rhState;
}

sub order_imports
{
	my ($raImports) = @ARG;
	my @Imports = map {
		join('', @{$ARG->{lines}})
	} sort by_length @$raImports;

	return \@Imports;
}

sub get_length
{
	my $HUGE = 1000;
	my ($rhImport) = @ARG;
	my $length = $rhImport->{type} eq 'RELATIVE' ? $HUGE - $rhImport->{length} : $rhImport->{length};
	return $length;
}

sub by_length
{
	my $a_length = get_length($a);
	my $b_length = get_length($b);
	return $a_length <=> $b_length
		|| join('', @{$a->{lines}}) cmp join('', @{$b->{lines}});
}

sub process_input
{
	my ($content) = @ARG;
	print "process_input(@{[length($content)]})\n" if $TRACE;
	my $rhState = start_state();
	$rhState->{top} = $content;
	while ($rhState->{state} ne 'AFTER')
	{
		print "Before: " . Dumper($rhState) if $TRACE > 2;
		$rhState = parse_from_top($rhState, $rhState->{top});
		print "Parsed: " . Dumper($rhState) if $TRACE > 2;
		$rhState = state_change($rhState);
	}
	return join('', @{$rhState->{output}});
}

#===========================================================================
# unit test functions
#===========================================================================

sub test_start_state
{
	my ($expect) = @ARG;
	my $rhState = start_state();
	is_deeply($rhState, $expect, "start_state: $rhState->{state} == $expect->{state}")
}

sub test_parse_from_top
{
	my ($expect, $top, $rhState, $description) = @ARG;
	unless (ref($rhState)) {
		$description = $rhState;
		$rhState = start_state();
	}
	my $rhResult = parse_from_top($rhState, $top);
	is_deeply($rhResult, $expect, "parse_from_top: $description")
}

sub test_state_change
{
	my ($expect, $rhState, $description) = @ARG;
	my $rhResult = state_change($rhState);
	is_deeply($rhResult, $expect, "state_change: $description")
}

sub test_get_length
{
	my ($expect, $rhImport, $description) = @ARG;
	my $result = get_length($rhImport);
	is($result, $expect, "get_length: $description");
}

sub test_by_length
{
	my ($expect, $rhA, $rhB, $description) = @ARG;
	my @Result = sort by_length ($rhA, $rhB);
	is_deeply(\@Result, $expect, "sort by_length: $description")
}

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_start_state({
		state => 'BEFORE',
		output => [],
		imports => [],
		lines => [],
		token => '',
		found => '',
		top => '',
		'import' => undef,
	});

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'BLANKS',
			found => " \n  \n   \n",
			top => "  crap",
			'import' => undef,
		},
		" \n  \n   \n  crap",
		"blank lines");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'COMMENT_BLOCK',
			found => "  /* filename.js - the top of the file\n   more comment block text */\n",
			top => "   more crap",
			'import' => undef,
		},
		"  /* filename.js - the top of the file\n   more comment block text */\n   more crap",
		"comment block");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'COMMENT_LINE',
			found => "  // filename.js - the top of the file\n",
			top => "   leftover crap",
			'import' => undef,
		},
		"  // filename.js - the top of the file\n   leftover crap",
		"comment line");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'CODE',
			found => "const width = 32;\n",
			top => "  something else",
			'import' => undef,
		},
		"const width = 32;\n  something else",
		"a line of code");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'COMMENT_LINE',
			found => "  // filename.js - the top of the file\n",
			top => " // whatever else\n   other crap",
			'import' => undef,
		},
		"  // filename.js - the top of the file\n // whatever else\n   other crap",
		"multiple comment lines");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "   import 'path/filename'; /* stuff */\n",
			'import' => {
				length => 26,
				type => 'PACKAGE',
				lines => [
					"   import 'path/filename'; /* stuff */\n",
				],
			},
			top => "   some other crap",
		},
		"   import 'path/filename'; /* stuff */\n   some other crap",
		"import with no variables");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "   import X, {\n  Y,\n  Z } from 'path/filename'; /* stuff */\n",
			'import' => {
				length => 27,
				type => 'PACKAGE',
				lines => [
					"   import X, {\n",
					"  Y,\n",
					"  Z } from 'path/filename'; /* stuff */\n",
				],
			},
			top => "   some other crap",
		},
		"   import X, {\n  Y,\n  Z } from 'path/filename'; /* stuff */\n   some other crap",
		"import across lines with newline at end");

	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "// import X, { Y, Z } from 'path/filename'; /* stuff */\n",
			'import' => {
				length => 41,
				type => 'PACKAGE',
				lines => [
					"// import X, { Y, Z } from 'path/filename'; /* stuff */\n",
				],
			},
			top => "   some other crap",
		},
		"// import X, { Y, Z } from 'path/filename'; /* stuff */\n   some other crap",
		"commented import is recognised");

	my $state_with_comment = start_state();
	$state_with_comment->{lines} = [
		"// eslint-disable-next-line no-extraneous-dependencies\n",
	];
	test_parse_from_top({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
			'import' => {
				length => 29,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line no-extraneous-dependencies\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			},
			top => "",
		},
		"   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
		$state_with_comment,
		"import across lines to end of file");

	test_state_change({
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => ['// comment line\n'],
			token => 'COMMENT_LINE',
			found => '// comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => [],
			token => 'COMMENT_LINE',
			found => '// comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		"store a comment line",
	);

	test_state_change({
			state => 'BEFORE',
			output => ['// comment line\n'],
			imports => [],
			lines => ['// another comment line\n'],
			token => 'COMMENT_LINE',
			found => '// another comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => ['// comment line\n'],
			token => 'COMMENT_LINE',
			found => '// another comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		"flush and store another comment line",
	);

	test_state_change({
			state => 'BEFORE',
			output => ['// comment line\n'],
			imports => [],
			lines => ['// another comment line\n'],
			token => 'COMMENT_LINE',
			found => '// another comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => [],
			imports => [],
			lines => ['// comment line\n'],
			token => 'COMMENT_LINE',
			found => '// another comment line\n',
			top => 'something else\n',
			'import' => undef,
		},
		"flush and store another comment line",
	);

	test_state_change({
			state => 'BEFORE',
			output => [
				'// a comment line\n',
				'// another comment line\n',
				'  \n',
			],
			imports => [],
			lines => [],
			token => 'BLANKS',
			found => '  \n',
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => ['// a comment line\n'],
			imports => [],
			lines => ['// another comment line\n'],
			token => 'BLANKS',
			found => '  \n',
			top => 'something else\n',
			'import' => undef,
		},
		"blanks, flush what we have and keep looking",
	);

	test_state_change({
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => [],
			token => 'IMPORT',
			found => "   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => ['// a comment line\n'],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
			'import' => {
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			},
			top => 'something else\n',
		},
		"enter imports section",
	);

	test_state_change({
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 57,
				type => 'RELATIVE',
				lines => [
					"// import X, { Y, Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => [],
			token => 'IMPORT',
			found => "// import X, { Y, Z } from './path/filename'; /* stuff */",
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'BEFORE',
			output => ['// a comment line\n'],
			imports => [],
			lines => [],
			token => 'IMPORT',
			found => "// import X, { Y, Z } from './path/filename'; /* stuff */",
			'import' => {
				length => 57,
				type => 'RELATIVE',
				lines => [
					"// import X, { Y, Z } from './path/filename'; /* stuff */",
				],
			},
			top => 'something else\n',
		},
		"commented import is tracked",
	);

	test_state_change({
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}, {
				length => 27,
				type => 'PACKAGE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import A, {\n",
					"  B,\n",
					"  C } from 'path/filename';",
				],
			}],
			lines => [],
			token => 'IMPORT',
			found => "   import A, {\n  B,\n  C } from 'path/filename';",
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => [],
			token => 'IMPORT',
			found => "   import A, {\n  B,\n  C } from 'path/filename';",
			'import' => {
				length => 27,
				type => 'PACKAGE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import A, {\n",
					"  B,\n",
					"  C } from 'path/filename';",
				],
			},
			top => 'something else\n',
		},
		"got another import",
	);

	test_state_change({
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => ["// save a comment line\n"],
			token => 'COMMENT_LINE',
			found => "// save a comment line\n",
			top => 'something else\n',
			'import' => undef,
		},
		{
			state => 'IMPORTS',
			output => ['// a comment line\n'],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => [],
			token => 'COMMENT_LINE',
			found => "// save a comment line\n",
			'import' => undef,
			top => 'something else\n',
		},
		"comment line after an import",
	);

	test_state_change({
			state => 'AFTER',
			output => [
				"// a comment line\n",
				"// eslint-disable-next-line\n   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
				"// save a comment line\n",
				"// a second comment line\n",
				"something else\n",
			],
			imports => [],
			lines => [],
			token => 'COMMENT_LINE',
			found => "",
			top => '',
			'import' => undef,
		},
		{
			state => 'IMPORTS',
			output => ["// a comment line\n"],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => ["// save a comment line\n"],
			token => 'COMMENT_LINE',
			found => "// a second comment line\n",
			'import' => undef,
			top => "something else\n",
		},
		"a second comment line after an import",
	);

	test_state_change({
			state => 'AFTER',
			output => [
				"// a comment line\n",
				"// eslint-disable-next-line\n   import X, {\n  Y,\n  Z } from './path/filename'; /* stuff */",
				"// save a comment line\n",
				"  \n  \n",
				"something else\n",
			],
			imports => [],
			lines => [],
			token => 'BLANKS',
			found => "",
			top => '',
			'import' => undef,
		},
		{
			state => 'IMPORTS',
			output => ["// a comment line\n"],
			imports => [{
				length => 41,
				type => 'RELATIVE',
				lines => [
					"// eslint-disable-next-line\n",
					"   import X, {\n",
					"  Y,\n",
					"  Z } from './path/filename'; /* stuff */",
				],
			}],
			lines => ["// save a comment line\n"],
			token => 'BLANKS',
			found => "  \n  \n",
			'import' => undef,
			top => "something else\n",
		},
		"anything else after an import",
	);

	test_get_length(1000 - 12, {
		type => 'RELATIVE',
		length => 12,
	}, "length for RELATIVE import");

	test_get_length(12, {
		type => 'PACKAGE',
		length => 12,
	}, "length for PACKAGE import");

	test_by_length([{
			type => 'PACKAGE',
			length => 20,
			lines => [
				"import X from 'yes';\n"
			]}, {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
			}], {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
		}, {
			type => 'PACKAGE',
			length => 20,
			lines => [
				"import X from 'yes';\n"
			],
		},
		"PACKAGE vs RELATIVE same length",
	);

	test_by_length([{
			type => 'PACKAGE',
			length => 20,
			lines => [
				"import X from 'yes';\n"
			]}, {
			type => 'PACKAGE',
			length => 21,
			lines => [
				"import X from 'yess';\n"
			],
			}], {
			type => 'PACKAGE',
			length => 21,
			lines => [
				"import X from 'yess';\n"
			],
		}, {
			type => 'PACKAGE',
			length => 20,
			lines => [
				"import X from 'yes';\n"
			],
		},
		"PACKAGE ascending length",
	);

	test_by_length([{
			type => 'RELATIVE',
			length => 21,
			lines => [
				"import X from './ys';\n"
			]}, {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
			}], {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
		}, {
			type => 'RELATIVE',
			length => 21,
			lines => [
				"import X from './ys';\n"
			],
		},
		"RELATIVE descending length",
	);

	test_by_length([{
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './a';\n"
			]}, {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
			}], {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './y';\n"
			],
		}, {
			type => 'RELATIVE',
			length => 20,
			lines => [
				"import X from './a';\n"
			],
		},
		"alphabetical when equal length",
	);

	exit 0;
}
