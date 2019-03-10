#!/bin/bash
# A script to do multiple search and replaces across files in git control.
# Needs to be customised by hand...

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

git grep -iE 'card[ \-]servicing|view[ \-]?pin|ibreg'
LIST=`git grep -liE 'card[ \-]servicing|view[ \-]?pin|ibreg'`

for f in $LIST; do
	echo $f
	cp $f $f.bak
	perl -pne '
		s{view-pin-application}{payments}xmsg;
		s{\./view-pin}{./make-payment}xmsg;
		s{view-pin}{o4b-payments}xmsg;
		s{card-servicing}{o4b-bib}xmsg;
		s{card\sservicing}{Online For Business - Business Internet Banking}xmsgi;
		s{View\sPin}{O4B Payments}xmsgi;
		s{viewPin}{makePayment}xmsg;
		s{ViewPin}{MakePayment}xmsg;
		s{viewpin}{o4b-make-payment}xmsg;
		s{/ibreg/}{/cwa-app/}xmsg;
		s{ibreg}{o4b-make-payment}xmsg;
	' $f.bak > $f
done
find . -name '*.bak' -delete

# git stash save crap; git stash drop
