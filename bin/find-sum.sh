#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# find-sum easy find shows just checksum, size, name and symlink destination
# caveat -- only works well with file names that have no spaces in them.

# See also wymlink.sh for emulating symbolic links on windows

# using cksum:
# 677252015 9 "./list.txt"
# 677252015 9 "./xxx.lse" -> "list.txt"

# using md5sum:
# 8052fdd2c8af1a27262a9210acd1fe58 "./list.txt"
# 8052fdd2c8af1a27262a9210acd1fe58 "./xxx.lse" -> "list.txt"

if [ -z "$SUM" ]; then
	SUM=cksum
	if which md5sum > /dev/null; then
		SUM=md5sum
	fi
fi
#echo SUM=$SUM

add-checksums () {
  SUM=$SUM perl -pne '
    my @split = split(/\s+->\s+/, $_);
    my $file = $split[0];
    my @checksum = split(/\s+/, `$ENV{SUM} $file`);
    pop(@checksum);
    my $checksum = join(" ", @checksum);
    $_ = qq{$checksum $_}
  ' | sort
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
			| grep -v DS_Store \
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
			# windows
			echo No support for windows as yet.
			# TODO as there are no symlinks allowed, all we can do is examine existing inheritance.lst files
			# and update the entries that are not SYM links. We rely on wymlink -c to check that file contents
			# of symlinks haven't changed.  If they do, the Windows developer will have to manually change the
			# inheritance.lst file and update the checksum manually.
			exit 1
		fi

		# linux output:
		# lrwxrwxrwx 1 me me 8 Jun  3 11:39 ./xxx.lse -> list.txt
		# -rw-rw-r-- 1 me me 9 Jun  3 11:37 ./list.txt
		pushd "$sourceDir" > /dev/null \
			&& pwd | perl -pne 's{\A.+/(src/)}{$1}xms' \
			&& find . \( -type f -o -type l \) -printf '"%h/%f" -> "%l"\n' \
			| perl -pne 's{\s+->\s+""}{}xms' \
			| add-checksums \
		&& popd > /dev/null
	fi
}

find-sum "${1:-.}"
