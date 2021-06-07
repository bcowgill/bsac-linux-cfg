#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [-s] [-c] [--help|--man|-?] directory

This will emulate symbolic links on windows (i.e. wymlinks) by copying the link target file to where the link is.

directory  optional directory to switch into before simulating the links.
-s         Set up wymlinks from all inheritance.lst files found (like ln -s command)
-c         Confirm that emulated link file contents have not changed so they can be committed.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

This command expects the find-sum.sh command to have been run first to generate inheritance.lst files in directories which contain symbolic links.

With no options, this command simply finds all the ineritance.lst files and shows the symbolic link files and their targets.

Then, using -s option it converts the symbolic links on Windows to actual file copies and can restore the copies back to symbolic links with -c option if the contents have not changed.

This allows symbolic links created on Mac or Linux and committed to a git repository to somewhat work on Windows.

See also find-sum.sh, ln, cksum, md5sum

Example:

on Mac/Linux

find-sum.sh > inheritance.lst
git add inheritance.lst ...

on Windows

git pull...
wymlink.sh -s

before committing changes...

wymlink.sh -c
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

MODE="$1"
DIR=${2:-.}

pushd "$DIR" && find . -name 'inheritance.lst' | MODE=$MODE perl -MFile::Copy -ne '
	use Fatal qw{open move copy unlink};
	sub debug { return; print "dbg: "; print @_; }
	my $chide = "This would be easier if you were using an OS which supported symbolic links.";
	BEGIN { debug("MODE=$ENV{MODE}\n") }

	eval # try...
	{
		chomp;
		my $file = $_;
		debug("$file\n");
		my $dir = $file;
		$dir =~ s{/[^/]*\z}{}xmsg;
		print("in $dir/\n");
		my $fh;
		open($fh, "<", $file);
		while (my $line = <$fh>)
		{
			# 8052fdd2c8af1a27262a9210acd1fe58 "./xxx.lse" -> "list.txt"
			if ($line =~ m{"\./(.+)"\s*->\s*"(.*)"}xms)
			{
				print("$line\n");
				my $link_name = "$dir/$1";
        my $target_name = $2;
        debug("sym1 $link_name target $target_name\n");
        my $link_dir = $link_name;
        $link_dir =~ s{/[^/]+\z}{}xms;
        my $target_original = "$link_dir/$target_name";
        $target_name = $target_original;
				my $wym_name = "$link_name.wym";
        debug("sym2 $link_name target $target_name wym $wym_name\n");
        # correct relative directory upwards /somedir/../ => /
        while ($target_name =~ s{/([^/]+)/\.\./}{/}xmsg)
        {
          my $dir = $1;
          if ($dir =~ m{\A\.\.?\z}xms)
          {
            $target_name = $target_original;
          }
          last if $target_name eq $target_original;
        }
				debug("fixed target $target_name\n");
        debug(`pwd`);
				if ($ENV{MODE} eq "-s")
				{
					debug("attempting wymlink...\n");
					die "$target_name target of link $link_name does not exist, cannot create wymlink.\n" if ! -e $target_name;
					die "$wym_name already exists, cannot create wymlink.\n" if -e $wym_name;
					move($link_name, $wym_name);
					copy($target_name, $link_name);
					print "wymlink copied $target_name to $link_name backed up to $wym_name\n";
				}
				elsif ($ENV{MODE} eq "-c")
				{
					debug("attempting wymlink confirmation...\n");
					die "$wym_name is missing, did you forget to create the wymlinks?\n" if ! -e $wym_name;
					die "$target_name target of link $link_name does not exist, cannot confirm wymlink.  Did you remove the file?\n" if ! -e $target_name;
					my $result = system(qq{diff "$link_name" "$target_name" > /dev/null});
					die "$link_name differs from $target_name wymlink broken.  Do you need to convert from a link to a file copy before committing?\n" if $result;
					unlink($link_name);
					move($wym_name, $link_name);
					print "wymlink restored link $link_name to $target_name\n";
				}

			}
		}
	};
	if ($@) # catch...
	{
		die "$@$chide\n";
	}
'
popd
