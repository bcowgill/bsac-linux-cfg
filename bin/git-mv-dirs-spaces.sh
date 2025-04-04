#!/bin/bash
# rename directories / files in git which have spaces in them

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] directory

This will git rename directories with spaces in them and substite underbars for spaces or dashes.

directory  The relative directory to begin the search for directories with spaces in them.
DRY     Environment varialble set to find the dirs and generate gitmv.sh but don't really rename the directories.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

The local file gitmv.sh will be overwritten to complete the move after all directories have been found.

See also git-mv-src.sh git-mv-dirs.sh

MUSTDO finish help.sh --add here filter these for relevant See also list...
git-abandon-changes.sh     git-grep-skipped.sh        git-mustdo.sh              git-shell
git-agelog.sh              git-grep2.sh               git-mv-src.sh              git-show-files-only.sh
git-bra.sh                 git-gui                    git-new-branch.sh          git-slay-branch.sh
git-branch-age.sh          git-gui--askpass           git-ot.pl                  git-tag.sh
git-branch-lists.sh        git-gui.sh                 git-patch-subdir.sh        git-test-files.sh
git-check-tests.sh         git-is-ahead.sh            git-patch.sh               git-undelete.sh
git-checkout-branch.sh     git-is-changed.sh          git-perltidy.sh            git-untracked.sh
git-citool                 git-is-clean.sh            git-rebase.sh              git-upload-archive
git-co.sh                  git-log-until.sh           git-receive-pack           git-upload-pack
git-cvsserver              git-ls-code.sh             git-remote-check.sh        git-use-diffmerge.sh
git-fail-if.pl             git-ls-diff.sh             git-rename.sh              git-use-kdiff3.sh
git-fetch-pull-request.sh  git-ls-merge-tree.sh       git-repocheck.sh           git-use-meld.sh
git-fix-tests.sh           git-merge-subdir.sh        git-rewind-manually.sh     git-use-winmerge.sh
git-fpr.sh                 git-merge.sh               git-rewind.sh
git-get-remote-branch.sh   git-mk-js-facade.sh        git-shame.sh

Example:

...
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
if [ -z "$1" ]; then
	usage 1
fi

DIR="$1"

if [ -e gitmv.sh ]; then
	echo The script gitmv.sh already exists, you need to remove it.
	exit 1
fi

touch gitmv.sh
chmod +x gitmv.sh

find $DIR -depth -type d \
	| grep ' ' \
	| perl -pne '
	chomp;
	$new = $_;
	$q = chr(34);
	$new =~ tr/ _/-/;
	$new =~ s{-+}{_}xmsg;
	$_ = "git mv $q$_$q $new\n\n";
	' > gitmv.sh

if [ -z "$DRY" ]; then
	echo Dry Run: gitmv.sh generated, examine it and run it to do the rename.
else
	./gitmv.sh
fi

exit 0
