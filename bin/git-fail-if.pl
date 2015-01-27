#!/usr/bin/env perl

=item OVERVIEW

    Making git bisect more useful
    By Ovid on July 4, 2014 9:27 AM

    Start bisecting
    Tell git this is a bad commit
    Go far enough back in history to find a commit where the test passes
    Rerun the test to make sure the test passes (very important)
    Tell git that this is a good commit

    At this point, git will automatically check out a commit halfway between the two commits. You rerun your test and if it passes, you type git bisect good. If it fails, you type git bisect bad. (There's a whole lot more that I'm not covering here). Even if you don't have a test to run, you can use git bisect and, for example, refresh your browser to look for that display bug you're trying to track down and then return to the command line and mark it good or bad as appropriate.

    Repeat this process a few times and eventually git bisect will tell you which commit first introduced the failure. Then you type git bisect reset to stop bisecting.

    And git bisect will happily run the test for you and mark commits good or bad as appropriate, using the exit code of the program. You just sit back and wait for it to finish. Much nicer.

    There are a couple of cases where this doesn't work, though. One case, obviously, is where you must manually verify good/bad and can't write a program to do this. Another case is where sometimes the test fails in different ways. When you do this manually, you can use git bisect skip to skip a commit (or various commits). However, this means falling back to the tedious manual usage of git bisect. Thus, I hacked together the following proof of concept:

    I dropped that into my path and named it fail_if. You pass it a string of text to look for (--contains for an exact match or --matches for a regex match). If that text is found in the programs STDERR, the fail_if exits with a non-zero exit status. Otherwise, it exits with 0 (success).

=item SOURCE

    http://blogs.perl.org/users/ovid/2014/07/making-git-bisect-more-useful.html

=item EXAMPLE

    Use the prove command to run tests and have STDERR examined by git-fail-if

    git bisect start; 
    git bisect bad;  
    git checkout HEAD~20; 
    prove ...
    git bisect good;

    git bisect run git-fail-if.pl --contains "Field 'user' doesn't have a default value" \
        prove t/path/to/test/that/sometimes/fails/in/different/ways.t

    Use a script which greps for some text and says whether the checkout is good or bad based on that

    git checkout develop
    git bisect start
    ./good-bad.sh 
    git bisect bad
    git checkout 748b7c399b770753c97d22b99227f56c1508bf54
    good-bad.sh 
    git bisect good
    git bisect run git-fail-if.pl --contains "CHECKOUT IS BAD" good-bad.sh


   good-bad.sh contains something like this:

   #!/bin/bash
   CHECK=`egrep has_click_limit views/fragments/campaign_details_budget.tt | wc -l`
   echo CHECK=$CHECK
   if [ 0 == $CHECK ] ; then
        perl -e 'print STDERR qq{CHECKOUT IS BAD\n}'
        exit 1
   else
        perl -e 'print STDERR qq{CHECKOUT IS GOOD\n}'
        exit 0
   fi

=cut


use strict;
use warnings;
use Getopt::Long;
use IPC::Open3;
use Symbol qw(gensym);

GetOptions(
    'contains=s' => \my $contains,
    'matches=s'  => \my $matches,
) or usage();

usage() unless $contains xor $matches;
usage() unless @ARGV;

my $command = join ' ' => @ARGV;

my $stderr = gensym;
my $pid = open3( gensym, ">&STDERR", $stderr, $command );

my $output = '';
while ( my $err = <$stderr> ) {
    print STDERR $err;
    $output .= $err;
}

my $failed = $matches
  ? ( $output =~ qr/$matches/ )
  : ( index( $output, $contains ) > -1 );

waitpid( $pid, 0 );

exit $failed;

sub usage {
    die <<"END";
Usage:

$0 --contains 'exact text to fail on' command to run
$0 --matches  'pattern to fail on'    command to run
END
}
