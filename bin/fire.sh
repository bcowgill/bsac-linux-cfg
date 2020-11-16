#!/bin/bash
# WINDEV tool useful on windows development machine
#You mean you don't have an emergency commit script????? How unprofessional.
#Go to your terminal now...

#cat > ~/bin/fire.sh
#!/bin/bash
BRANCH=${1:-FIRE}

if git stash save "stash for emergency commit to $BRANCH"; then
	if git checkout -b $BRANCH; then
		NEWBRANCH=1
		echo OK emergency branch $BRANCH created
		git push --no-verify --set-upstream origin $BRANCH
	fi
	git stash apply
	if [ ! -z $NEWBRANCH ]; then

		git add `git status | perl -ne '
		if (!$found) {
			$found = 1 if m{
				\A (Untracked \s files:)
			}xms
		}
		if (!$print && $found) {
			$print = 1 if m{\A \t}xms;
		}
		print if $print && m{\A \t}xms;
		'`
		git commit --no-verify -am "EMERGENCY COMMIT $BRANCH"
		git push --no-verify
	else
		echo NOT OK emergency branch $BRANCH NOT created
		exit 1
	fi
fi
#^D
#chmod +x ~/bin/fire.sh
