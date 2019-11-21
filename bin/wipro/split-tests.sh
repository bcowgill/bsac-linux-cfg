#!/bin/bash
# create a markdown checkbox list of cypress tests for each team member
# i.e.
# # part 1
# * [ ] 355-2-remove-for-mobile-multiple-payment.dev.feature
PEOPLE="sandy.lst ammy.lst shabby.lst brent.lst"
if [ ! -z "$1" ]; then
	PEOPLE="$*"
fi

pushd /Users/bcowgill/workspace/projects/o4b/o4b-payments-bdd
pushd cypress/integration

# find cypress features which are not all skipped (usually new stories)
echo \* `ls PAY*.dev.feature | wc -l` cypress dev feature files
for file in PAY*.dev.feature
do
	SCENARIOS=`grep -E '^\s*Scenario' $file | wc -l`
	SKIPS=`grep -E '@skip' $file | wc -l`
	[ "$SCENARIOS" != "$SKIPS" ] && echo "$file" >> tests.txt
done
echo \* `cat tests.txt | wc -l` feature files with enabled tests

# clean up names and sort randomly by the number
perl -pne 's{PAYO4B-+}{}xms' tests.txt \
	| sort --sort=random\
	> test-list.txt

split-list.pl test-list.txt $PEOPLE \

for file in $PEOPLE
do
	echo \* `cat $file | wc -l` $file
done
echo " "

# convert lines to checkboxes and show names in sorted order
for file in $PEOPLE
do
	echo "# $file" | perl -pne 's{\.lst}{}xms'
	cat $file | sort --sort=numeric | perl -pne 's{\A}{* [ ] }xms'
	echo " "
done

rm tests.txt test-list.txt $PEOPLE

