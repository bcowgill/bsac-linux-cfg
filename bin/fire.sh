#!/bin/bash
#You mean you don't have an emergency commit script????? How unprofessional.
#Go to your terminal now...

#cat > ~/bin/fire.sh
#!/bin/bash
git stash save
git checkout -b FIRE && git push --set-upstream origin FIRE
git stash apply

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

git commit -am "EMERGENCY COMMIT"
git push
#^D
#chmod +x ~/bin/fire.sh

