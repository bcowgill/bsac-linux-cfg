#!/usr/bin/env perl
# make a test plan for a javascript file

#files-ui/lib/scripts/filesview/collections/CollectionCopyMixin.js
# --> test/spec/filesview/collections/CollectionCopyMixin.spec.js

use strict;
use warnings;
use English qw(-no_match_vars);
use File::Path qw(make_path);
use File::Slurp qw(write_file);

my $javascript;

my $TRACE = 0;
my $REGEX_JAVASCRIPT = qr{\A (.+/) (?:lib|app)/scripts/ (.+ /)? ([^/]+) (\.js) \z}xms;

my $TEST_PLAN = read_data();

sub read_data
{
	local $INPUT_RECORD_SEPARATOR = undef;
	return <DATA>;
}

sub make_test_plan
{
	my ($javascript) = @ARG;

	if ($javascript !~ m{\A [\./]}xms) {
		$javascript = "./$javascript";
	}
	print "[$javascript]\n" if $TRACE;

	if ($javascript =~ $REGEX_JAVASCRIPT)
	{
		my ($prefix, $subpath, $filename, $ext) = ($1, $2, $3, $4);

		$prefix =~ s{\A \./}{}xms;
		print "[$prefix] [$subpath] [$filename] [$ext]\n" if $TRACE;

		my $testdir  = "${prefix}test/spec/$subpath";
		my $testname = "$filename.spec$ext";
		my $fullname = "$testdir$testname";


		print "[$testdir] [$testname] [$fullname]\n" if $TRACE;

		make_path($testdir, { verbose => 1 });
		if (! -e $fullname)
		{
			print "make test plan $fullname\n";
			my $content = $TEST_PLAN;
			$content =~ s{OBJECT}{$filename}xmsg;
			$content =~ s{PATH}{$subpath$filename}xmsg;
			write_file($fullname, { err_mode => 'carp' }, $content);
		}
		else
		{
			warn "$fullname: test plan already exists\n";
		}
	}
	else
	{
		warn("$javascript did not match $REGEX_JAVASCRIPT");
	}
}

foreach my $javascript (@ARGS)
{
	make_test_plan($javascript);
}

__DATA__
define(function (require) {
	'use strict';

	var OBJECT = require('PATH'),
		mockFactory = require('mockFactory'),
		fixtures = require('fixtures'),
		_ = require('underscore'),
		bShow = true,
		testHelper;

	describe('OBJECT', function () {

		before(function () {
			_.extend(this, testHelper);
		});

		beforeEach(function () {
			this.setUp();
		});

		afterEach(function () {
			this.tearDown();
		});

		describe('initialize', function () {

			it.skip('should test something when initialized', function () {
				// Arrange
				// Act
				// Assert
			});

		});

		describe.skip('Render', function () {

			it('should display something', function () {
				// Arrange
				// Act
				// Assert
			});

		});

		describe.skip('Events', function () {

			it('should do something when events happen', function () {
				// Arrange
				// Act
				// Assert
			});

		});

	});

	testHelper = {

		setUp: function () {
			mockFactory.createApplication();
			this.requests = mockFactory.installFakeAjax();

			this.view = new OBJECT();

			fixtures.render(this.view, bShow);
		},

		tearDown: function () {
			mockFactory.uninstallFakeAjax();
			mockFactory.deleteApplication();
			fixtures.reset();
		}
	};

});
