#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] directory

This will scan a directory tree given for certain files and generate a checksum (cksum or md5) listing for later comparison.

SUM        Environment variable to specify an alternative checksum program.
directory  The directory to scan and generate an inheritance.lst file in.
--man      Shows help for this tool.
--help     Shows help for this tool.
-?         Shows help for this tool.

Lists the checksum, size, name and symlink destination for files.
If md5 checksum is used, the size is omitted.

Caveat -- only works well with file names that have no spaces in them.

Example output:
	using cksum:
	677252015 9 "./list.txt"
	677252015 9 "./xxx.lse" -> "list.txt"

	using md5sum:
	8052fdd2c8af1a27262a9210acd1fe58 "./list.txt"
	8052fdd2c8af1a27262a9210acd1fe58 "./xxx.lse" -> "list.txt"

See also wymlink.sh for emulating symbolic links on Windows.

Example:

	$cmd subdir > subdir/inheritance.lst
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

if [ -z "$SUM" ]; then
	SUM=cksum
	if which md5sum > /dev/null; then
		SUM=md5sum
	fi
fi
#echo SUM=$SUM

BLAT=`mktemp`

add-checksums () {
	OSTYPE=$OSTYPE SUM=$SUM BLAT=$BLAT perl -pne '
		my @split = split(/\s+->\s+/, $_);
		my $file = $split[0];
		chomp $file;
		my $tmp = $file;
		my @checksum;
		if ($ENV{OSTYPE} eq "msys" && `file -b $file | grep text`)
		{
			# windows newline characters differ so checksum on text files differ!!
			$tmp = $ENV{BLAT};
			system(qq{dos2unix -n $file $tmp});
		}
		@checksum = split(/\s+/, `$ENV{SUM} $tmp`);
		pop(@checksum);
		my $checksum = join(" ", @checksum);
		$_ = qq{$checksum $_};
	' | sort
}

filter-out () {
	grep -v DS_Store \
	| grep -vE '\.wym\s*$' \
	| grep -v inheritance.lst
}

find-sum () {
	local sourceDir
	sourceDir="$1"
	if which sw_vers > /dev/null 2>&1 ; then
		# MACOS
		# -rw-r--r--@ 1 bcowgill  staff    48K 30 Apr 06:25 ./IntroConversationBgrMobile.jpg
		# lrwxr-xr-x  1 bcowgill  staff    25B  3 Jun 10:27 ./Logotype.js -> ../mc-demo-eu/Logotype.js
		# first convert to simple output name, target name
		# ./Logotype.js -> ../mc-demo-eu/Logotype.js
		# ./config.js
		# then add in checksum as prefix to line
		# 714223608 303 config.js
		pushd "$sourceDir" > /dev/null \
			&& pwd | perl -pne 's{\A.+/(src/)}{$1}xms' \
			&& find . \( -type f -o -type l \) -exec ls -lh {} \; \
			| filter-out \
			| perl -pne '
				chomp;
				s{\A.+?\s+(\./)}{$1}xms;
				$_ = qq{"$_"\n};
				s{(\s+->\s+)}{"$1"}xms
			' \
			| add-checksums \
		&& popd > /dev/null
	else
		if [ "$OSTYPE" == "msys" ]; then
			# windows output: (no symlinks, emulated by .wym files instead)
			# lrwxrwxrwx 1 me me 8 Jun  3 11:39 ./xxx.lse
			# lrwxrwxrwx 1 me me 8 Jun  3 11:39 ./xxx.lse.wym
			# -rw-rw-r-- 1 me me 9 Jun  3 11:37 ./list.txt
			pushd "$sourceDir" > /dev/null \
				&& pwd | perl -pne 's{\A.+/(src/)}{$1}xms' \
				&& find . \( -type f \) -exec ls -lh {} \; \
				| filter-out \
				| perl -pne '
					chomp;
					s{\A.+?\s+(\./)}{$1}xms;
					$_ = qq{"$_"\n};
					s{(\s+->\s+)}{"$1"}xms
				' \
				| add-checksums \
			&& popd > /dev/null
		else
			# linux output:
			# lrwxrwxrwx 1 me me 8 Jun  3 11:39 ./xxx.lse -> list.txt
			# -rw-rw-r-- 1 me me 9 Jun  3 11:37 ./list.txt
			pushd "$sourceDir" > /dev/null \
				&& pwd | perl -pne 's{\A.+/(src/)}{$1}xms' \
				&& find . \( -type f -o -type l \) -printf '"%h/%f" -> "%l"\n' \
				| filter-out \
				| perl -pne 's{\s+->\s+""}{}xms' \
				| add-checksums \
			&& popd > /dev/null
		fi
	fi
	rm $BLAT
}

find-sum "${1:-.}"
