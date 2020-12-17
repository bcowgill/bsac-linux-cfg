#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show or strip comments from source code
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English -no_match_vars;
use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use autodie qw(open cp);
use open IN => ':raw';
use FindBin;

local $INPUT_RECORD_SEPARATOR = undef;

my $bl = qr{(\A|\n)}xms;
my $el = qr{(\z|\n)}xms;

my $INPLACE;
my $STRIP   = 1;
my $SHOW    = 'keep';
my $JAVADOC = ''; # or strict or undefined
my $BRACE_MARKERS = 1;
my %Keep = (
	eslint   => 1,
	jslint   => 0,
	jshint   => 0,
	jscs     => 0,
	istanbul => 0,
	prettier => 1,
	nosonar  => 1,
);
my %Directive = (
	eslint   => 1,
	jslint   => 1,
	jshint   => 1,
	jscs     => 1,
	prettier => 1,
	nosonar  => 1,
);
my $KEEP_RE;
my $DIRECTIVE_RE;

my @directives = ();
my @comments = ();
my @keep_comments = ();

process_args();
check_options();
main();

sub usage
{
	my ($message) = @ARG;
	my $cmd = $FindBin::Script;

	print "$message\n\n" if ($message);
	print <<"USAGE";
usage: $cmd [options] filename...

Strips out C/C++ style comments from source code in files specified.

--inplace=.bak will edit the file in place backing up to file extension provided.
--show will show the comments which would be stripped, but leaves them in place.
--keep will show the comments which are kept, without stripping anything from the file.
--braces or --nobraces    allows or strips comments immediately after a closing brace
--eslint or --noeslint    allows or strips eslint directive comments, allowed by default
--jslint or --nojslint    allows or strips jslint directive comments
--jshint or --nojshint    allows or strips jshint directive comments
--jscs or --nojscs        allows or strips jscs directive comments
--prettieror --prettier   allows or strips prettier directive comments, allowed by default
--istanbulor --noistanbul allows or strips istanbul directive comments
--sonar      --nosonar    allows or strips sonar directive comments, allowed by default
--nojavadoc or --javadoc=strip strips out all javadoc comments
--javadoc=lite                 allows all javadoc comments
--javadoc or --javadoc=strict  allows only javadoc comments with a \@word reference in them
--help show the command help you are reading now

Allows any permitted directive comments (eslint, etc) at the top of the file.
Allows a single contiguous comment block at top of file after the directives.
Strips out all other comments which do not begin with an apology.
Allows comments containing a URL as they are probably documenting something difficult.
Allows by default a comment after a closing brace so you can document the condition that started that scope.
By default allows eslint, prettier and sonar comment directives only.
USAGE
	exit ($message ? 1 : 0);
}

sub process_args
{
	if (scalar(@ARGV) && $ARGV[0] eq '--help')
	{
		usage();
	}

	while (scalar(@ARGV) && $ARGV[0] =~ m{\A --}xms)
	{
		my $option = shift(@ARGV);
		my $reOpt = qr{\A --(no)?((esl|jsl|jsh)int|jscs|istanbul|prettier) \z}xms;
		# print "process_args: [$option] $reOpt @{[($option =~ $reOpt) ? 1 : 0]}\n";
		if ($option eq '--show')
		{
			$STRIP = 0;
			$SHOW = 'stripped';
		}
		elsif ($option eq '--keep')
		{
			$STRIP = 0;
			$SHOW = 'keep';
		}
		elsif ($option =~ m{\A --(no)?sonar \z}xms)
		{
			$Keep{nosonar} = ($1 ? 0 : 1);
		}
		elsif ($option =~ $reOpt)
		{
			if (exists($Keep{$2}))
			{
				$Keep{$2} = ($1 ? 0 : 1);
			}
			else
			{
				usage("Invalid option $option");
			}
		}
		elsif ($option =~ m{\A --(no)?javadoc(=(strip|strict|lite))? \z}xms)
		{
			if ( $1 || ($3 && $3 eq 'strip'))
			{
				$JAVADOC = '';
			}
			elsif ($3)
			{
				$JAVADOC = $3;
			}
			else
			{
				$JAVADOC = 'strict';
			}
		}
		elsif ($option =~ m{\A --(no)?brace \z}xms)
		{
			$BRACE_MARKERS = !$1;
		}
		elsif ($option =~ m{\A --inplace(=(.+))?}xms)
		{
			$SHOW = '';
			if (defined $2)
			{
				$INPLACE = $2;
			}
			else
			{
				$INPLACE = '';
			}
		}
		else
		{
			usage("Invalid option $option");
		}
	}
}

sub check_options
{
	if (defined $INPLACE)
	{
		usage("You cannot specify both --inplace and --$SHOW") if $SHOW;
		usage("You must specify a filename when using --inplace") unless scalar(@ARGV);
	}
}

sub main
{
	$KEEP_RE      = join('|', grep { $Keep{$ARG} } keys(%Keep));
	$DIRECTIVE_RE = join('|', grep { $Directive{$ARG} } keys(%Directive));
	if (scalar(@ARGV))
	{
		foreach my $file (@ARGV)
		{
			process_file($file);
		}
	}
	else
	{
		process_stdio();
	}
}

sub process_file
{
	my ($filename) = @ARG;
	print "$filename:\n";
	if (defined $INPLACE)
	{
		edit_file_inplace($filename, $INPLACE);
	}
	else
	{
		process_entire_file($filename);
	}
}

sub process_stdio
{
	my $file = <>;
	my $output = process_file_content($file);
	print $output;
}

sub edit_file_inplace
{
	my ($filename, $suffix) = @ARG;
	my $backup = "$filename$suffix";
	my $content = read_file($filename);
	my $output = process_file_content($content);
	if ($content ne $output)
	{
		unless ($filename eq $backup)
		{
			cp($filename, $backup);
		}
		write_file($filename, $output);
	}
}

sub process_entire_file
{
	my ($filename) = @ARG;
	my $content = read_file($filename);
	my $output = process_file_content($content);
	print $output;
}

sub process_file_content
{
	my ($file) = @ARG;

	$file =~ s{\A \s+}{}xmsg;

	# so that http:// is not mistaken for a // comment
	$file =~ s{(\w+:)//}{$1 / /}xmsg;

   # must pre-mark brace comments so they are not removed
	$file =~ s{(\} \s* //)}{$1sorry ALLOW BRACE MARKERS}xmsg if $BRACE_MARKERS;

	my $at_the_top = 1;
	@directives = ();
	@comments = ();
	@keep_comments = ();

	my $top_comment;
	my $comment;

	while ($at_the_top)
	{
		($comment, $file) = grab_one_comment($file);
		if (is_directive_comment($comment))
		{
			$comment =~ s{\s* \z}{}xms;
			# print "push directive: [$comment]\n";
			push(@directives, $comment) if is_kept_directive_comment($comment);
		}
		elsif (is_comment($comment))
		{
			$file = "$comment$file";
			#print "is comment:$file\n";
			($top_comment, $file) = grab_comment($file);
			($top_comment, $file) = omit_trailing_directives($top_comment, $file);
			$at_the_top = 0;
		}
		else
		{
			$at_the_top = 0;
		}
	}

	# print qq{directives: @{[join("\n", @directives)]}\ntop_comment: $top_comment\n};

	if ($top_comment)
	{
		push(@directives, $top_comment);
	}
	push(@keep_comments, @directives);

	# /***** something ******/
	# /* sorry, this is ok... */
	$file =~ s{
		(\s*)
		(/\*
			(\s*)
			(.*?)
		\*/)
		}{
		my ($prespace, $comment, $space, $message) = ($1, $2, $3, $4);
		replace_comment($prespace, $comment, $space, $message);
	}xmsgei;

	$file =~ s{
		(\s*)
		(// ([^\n]* \n))
		}{
		my ($prespace, $comment, $message) = ($1, $2, $3);
		my $space;
		($space, $message) = grab_it($message, qr{\A (\s+)}xms);
		replace_comment($prespace, $comment, $space, $message, "\n");
	}xmsgei;

	my $output;
	if ($STRIP)
	{
		$output = join("\n", @directives, "$file");
	}
	elsif ($SHOW eq 'keep')
	{
		$output = join("\n\n", @keep_comments);
	}
	else
	{
		$output = join("\n\n", @comments);
	}

	# undo special repacement protection markers for http and brace markers.
	$output =~ s{(\w+:)\s+/\s+/}{$1//}xmsg;
	$output =~ s{sorry \s+ ALLOW \s+ BRACE \s+ MARKERS}{}xmsg if $BRACE_MARKERS;

	$output =~ s{\n\n+}{\n\n}xmsg;
	$output =~ s{\s* \z}{\n}xms;
	return $output;
}

sub grab_it
{
	my ($string, $re) = @ARG;
	my $got = '';
	if ($string =~ m{$re}xms)
	{
		$string =~ s{$re}{}xms;
		$got = defined($1) ? $1 : '';
	}
	return ($got, $string);
}

sub grab_one_comment
{
	my ($file) = @ARG;
	my $top_comment;
	($top_comment, $file) = grab_it($file, qr{ \A (?:\s*) (/\* .*? \*/) }xms);
	($top_comment, $file) = grab_it($file, qr{ \A (?:\s*) (// [^\n]* $el) }xms) unless $top_comment;
	return ($top_comment, $file);
}

sub grab_comment
{
	my ($file) = @ARG;
	my $top_comment;
	($top_comment, $file) = grab_it($file, qr{ \A ( (\s*) (/\* .*? \*/) ) }xms);
	($top_comment, $file) = grab_it($file, qr{ \A ( (\s*) (// [^\n]* $el)+ ) }xms) unless $top_comment;
	return ($top_comment, $file);
}

sub omit_trailing_directives
{
	my ($comment_block, $file) = @ARG;
	if ($comment_block =~ m{\A //}xms)
	{
		my @comments = ();
		my @directives = split(/\n/, $comment_block);
		while (scalar(@directives))
		{
			my $comment = shift(@directives);
			if (is_directive_comment($comment))
			{
				unshift(@directives, $comment);
				last;
			}
			push(@comments, $comment);
		}
		$comment_block = join("\n", @comments);
		push(@directives, $file);
		$file = join("\n", @directives);
	}
	return ($comment_block, $file);
}

sub is_comment
{
	my ($message) = @ARG;
	return ($message =~ m{\A /[/*]}xms) ? 1 : 0;
}

sub is_directive_comment
{
	my ($message) = @ARG;
	my $result = ($message =~ m{ \A /[/*] \s* ($DIRECTIVE_RE) }xmsi) ? 1 : 0;
	#print "is_directive_comment: $result\n[$message]\n/$DIRECTIVE_RE/\n";
	return $result;
}

sub is_kept_directive_comment
{
	my ($message) = @ARG;
	if (length($KEEP_RE))
	{
		return ($message =~ m{ \A /[/*] \s* ($KEEP_RE) }xmsi) ? 1 : 0;
	}
	return 0;
}

sub keep_comment
{
	my ($prespace, $comment, $space, $message) = @ARG;
	my $punct = '';
	my $comma = '[,:\.]';
	($punct, $message) = grab_it($message, qr{\A([^a-z0-9\s]+ \s*)}xmsi);
	# print qq{\nkeep_comment: comment: [$comment]\npunct: [$punct]\nmessage: [$message]\nKEEP_RE: [$KEEP_RE]\n};
	my $result = 0;
	if (length($KEEP_RE) && $message =~ m{ \A $KEEP_RE }xmsi)
	{
		$result = 1;
	}
	elsif ($message =~ m{ \A (sorry|apologies)$comma? }xmsi)
	{
		$result = 2;
	}
	elsif ($message =~ m{ \w+:\s+/\s+/\w+ }xms)
	{
		# an escaped  url http: / /www....
		$result = 3;
	}
	elsif ($punct =~ m{\A \* \s*}xms)
	{
		if ($JAVADOC eq "strict")
		{
			$result = ($message =~ m{\@\w+}xms);
		}
		elsif ($JAVADOC)
		{
			$result = 4;
		}
	}
	# print qq{result: $result\n};
	return $result;
}

sub replace_comment
{
	my ($prespace, $comment, $space, $message, $with) = @ARG;
	my $replace;
	# print qq{\nreplace_comment comment: [$comment]\nmessage: [$message]\nwith: [$with]\n};
	if (keep_comment($prespace, $comment, $space, $message))
	{
		$replace = $prespace . $comment;
		# print qq{keep: replace: [$replace]\ncomment: [$comment]\n};
		push(@keep_comments, $comment);
	}
	else
	{
		$replace = $with || "";
		push(@comments, $comment);
	}
	return $replace;
}
