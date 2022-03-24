#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# summarize what is running with java or other things
# ps -ef --cols 256 | what-is-running.pl
# ps -ef --cols 256 | egrep "^($USER|`id -u`)" | what-is-running.pl
# WINDEV tool useful on windows development machine

use strict;
use English;

my $LOG_UNKNOWN = 0;
my $me = $ENV{USER};
my $prefix = "___";
while (my $line = <>)
{
	$line = "${prefix}BACKUP        $line\n" if $line =~ m{ezbackup}xms && $line !~ m{\scheck}xms;
	$line = "${prefix}CALIBRE       $line\n" if $line =~ m{python .+ calibre}xms;
	$line = "${prefix}DOCUZILLA     $line\n" if $line =~ m{mono .+ Docuzilla}xms;
	$line = "${prefix}WEBSERVER     $line\n" if $line =~ m{[pP]ython .+ (SimpleHTTP|http\.server)}xms;
	$line = "${prefix}CHARLES PROXY $line\n" if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;
	$line = "${prefix}ATOM IDE      $line\n" if $line =~ m{/Applications/Atom.app/Contents/Frameworks/Atom}xms;
	$line = "${prefix}WEBSTORM IDE  $line\n" if $line =~ m{java .+ $me/bin/WebStorm}xms;
	$line = "${prefix}GIT GUI       $line\n" if $line =~ m{git-gui}xms;
	$line = "${prefix}JEST          $line\n" if $line =~ m{react-scripts .+ test}xms;
	$line = "${prefix}KARMA         $line\n" if $line =~ m{node(js)? .+ karma \s* start}xms;
	$line =~ s{--grep}{--g-r-e-p}xmsg;
	$line = "${prefix}KARMAWEBSTORM $line\n" if $line =~ m{node(js)? .+ intellij .+ karma}xms;
	$line = "${prefix}KARMAWSSERVER $line\n" if $line =~ m{node(js)? .+ karma .+ capture}xms;
	$line = "${prefix}INTELLIJ IDE  $line\n" if $line =~ m{java .+ $me/bin/idea}xms;
	$line = "${prefix}INTELLIJ NODE $line\n" if $line =~ m{node(js)? .+ idea .+ JavaScriptLanguage}xms;
	$line = "${prefix}ALM WORKER    $line\n" if $line =~ m{node(js)? .+ /alm/ .+ workers}xms;
	$line = "${prefix}EMACS         $line\n" if $line =~ m{emacs}xms;
	$line = "${prefix}EXPRESS       $line\n" if $line =~ m{node(js)? .+ \./bin/www}xms;
	$line = "${prefix}CYPRESS       $line\n" if $line =~ m{node(js)? .+ \.bin/cypress}xms;
	$line = "${prefix}CYPRESS       $line\n" if $line =~ m{Cypress.app}xms;
	$line = "${prefix}WEBPACK       $line\n" if $line =~ m{node(js)? .+ webpack}xms;
	$line = "${prefix}FLOWSERVER    $line\n" if $line =~ m{node_modules .+ flow \s+ start}xms;
	$line = "${prefix}REACTSTORYBK  $line\n" if $line =~ m{node(js)? .+ storybook}xms;
	$line = "${prefix}NODESERVER    $line\n" if $line !~ m{\A___}xms && $line =~ m{node(js)? .+[sS]erver}xms;
	$line = "${prefix}DASHBOARD     $line\n" if $line =~ m{perl .+ infinity-plus-dashboard/bin/app\.pl}xms;
	$line = "${prefix}UPDAEMON      $line\n" if $line =~ m{perl .+ blis-location-uploadd.pl}xms;
	#/home/bcowgill/.rvm/rubies/ruby-2.1.5/bin/ruby bin/rails server -p 3001
	$line = "${prefix}RAILS SERVER  $line\n" if $line =~ m{ruby .+ rails \s+ s(erver)?}xms;
	$line = "${prefix}CONT SERVICE  $line\n" if $line =~ m{ruby \s+ \./cli \s+ start}xms;
	$line = "${prefix}GRUNT BUILD   $line\n" if $line =~ m{grunt}xms;

	$line = "${prefix}AUTOBUILD     $line\n" if $line =~ m{auto-build\.sh}xms;
	$line = "${prefix}KEEP IT UP    $line\n" if $line =~ m{keep-it-up\.sh}xms;
	$line = "${prefix}BALOO         $line\n" if $line =~ m{baloo_file_extractor}xms;
	$line = "${prefix}SCREENSHOT    $line\n" if $line =~ m{screenshot.sh}xms;
	print $line;
	if ($line !~ m{\A$prefix}xms)
	{
		log_process($line) if $LOG_UNKNOWN;
	}
}

sub log_process
{
	my ($process) = @ARG;
	my $fh;
	open($fh, ">>", "/tmp/$me/what-is-running.log") && print $fh "$process";
	close($fh);
}

__END__

