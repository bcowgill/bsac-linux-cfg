#!/bin/bash
# A script to do multiple search and replaces across files in git control.
# Needs to be customised by hand. See STEP markers below...
# STEP 0 make sure you have no modifications in your git repository, start from a fresh commit.
# modify STEP 1 pattern then run this script, it will show you the text matches and list the files which
# will be modified.
# a) If all looks correct do a git stash save replace.me changes for ....; git stash apply
# so that your changes to this script will not be lost.
# b) Run again with --now to perform the fix.
# c) git diff to see if the changes are correct. if not then just
# d) git stash save crap; git stash drop; git stash apply
# e) You can then make further changes to this script and try again from a)

# for real...
#MOVE='git mv'
#COMMIT='git commit -m'

# for testing
#MOVE='cp -R'
#COMMIT=echo

#[ -d src/journeys/cwa-app ] && rm -rf src/journeys/cwa-app

#$MOVE src/journeys/ibreg src/journeys/cwa-app
#$COMMIT "wip PAYO4B-16 Move src/journeys/ibreg src/journeys/cwa-app"
#$MOVE src/journeys/cwa-app/routes/view-pin.jsx src/journeys/cwa-app/routes/make-payment.jsx
#$COMMIT "wip PAYO4B-16 Move cwa-app/routes/view-pin.jsx cwa-app/routes/make-payment.jsx"

# STEP 1 specify grep pattern to find the files that need fixing.
GREP='multiple-payment-list-total-'

if [ "$1" != "--now" ]; then
  echo "Find matches: '$GREP'"
  git grep -iE "$GREP" | grep -v scripts/replace.me
fi

TEMPFILE=`mktemp`
git grep -liE "$GREP" | grep -v scripts/replace.me > $TEMPFILE
LIST=`cat $TEMPFILE`

if [ "$1" != "--now" ]; then
  echo " "
  echo "Find files matching: '$GREP'"
  cat $TEMPFILE
fi
rm $TEMPFILE

if [ "$1" != "--now" ]; then
	echo " "
	echo specify --now on command line to perform the replacement.
	exit 0
fi

for f in $LIST; do
  echo $f
  cp $f $f.bak
  perl -pne '
    # STEP 2 specify perl search and replace expressions for making your fixes.
    # BEGIN REPLACE CODE
    s{\bmultiple-payment-list-total-row\b}{multiple-payment-list-total-footer-row}xmsg;
    s{\bmultiple-payment-list-total-(footer-)?row-value\b}{total-value cell-value}xmsg;
    # END REPLACE CODE
  ' $f.bak > $f
done
find . -name '*.bak' -delete

# git stash save crap; git stash drop
