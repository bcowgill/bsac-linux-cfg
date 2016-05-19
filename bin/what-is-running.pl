#!/usr/bin/env perl
# summarize what is running with java or other things
# ps -ef | what-is-running.pl
# ps -ef | egrep "^($USER|`id -u`)" | what-is-running.pl

use strict;
use English;

my $prefix = "___";
while (my $line = <>)
{
	$line = "${prefix}WEBSERVER     $line\n" if $line =~ m{python .+ (SimpleHTTP|http\.server)}xms;
	$line = "${prefix}CHARLES PROXY $line\n" if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;
	$line = "${prefix}WEBSTORM IDE  $line\n" if $line =~ m{java .+ bcowgill/bin/WebStorm}xms;
	$line = "${prefix}EMACS         $line\n" if $line =~ m{emacs}xms;
	$line = "${prefix}KARMA         $line\n" if $line =~ m{node(js)? .+ karma \s* start}xms;
	$line = "${prefix}KARMAWEBSTORM $line\n" if $line =~ m{node(js)? .+ intellij .+ karma}xms;
	$line = "${prefix}KARMAWSSERVER $line\n" if $line =~ m{node(js)? .+ karma .+ capture}xms;
	$line = "${prefix}EXPRESS       $line\n" if $line =~ m{node(js)? .+ \./bin/www}xms;
	$line = "${prefix}WEBPACK       $line\n" if $line =~ m{node(js)? .+ webpack}xms;
	$line = "${prefix}FLOWSERVER    $line\n" if $line =~ m{node_modules .+ flow \s+ start}xms;
	$line = "${prefix}REACTSTORYBK  $line\n" if $line =~ m{node(js)? .+ storybook}xms;
	$line = "${prefix}DASHBOARD     $line\n" if $line =~ m{perl .+ infinity-plus-dashboard/bin/app\.pl}xms;
	$line = "${prefix}UPDAEMON      $line\n" if $line =~ m{perl .+ blis-location-uploadd.pl}xms;
	#/home/bcowgill/.rvm/rubies/ruby-2.1.5/bin/ruby bin/rails server -p 3001
	$line = "${prefix}RAILS SERVER  $line\n" if $line =~ m{ruby .+ rails \s+ s(erver)?}xms;
	$line = "${prefix}CONT SERVICE  $line\n" if $line =~ m{ruby \s+ \./cli \s+ start}xms;
	$line = "${prefix}GRUNT BUILD   $line\n" if $line =~ m{grunt}xms;

	$line = "${prefix}AUTOBUILD     $line\n" if $line =~ m{auto-build\.sh}xms;
	$line = "${prefix}KEEP IT UP    $line\n" if $line =~ m{keep-it-up\.sh}xms;
	$line = "${prefix}BALOO         $line\n" if $line =~ m{baloo_file_extractor}xms;
	print $line;
}
__END__

