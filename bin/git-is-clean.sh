# check if there are no local changes in your git repo
if [ 0 == `git diff | wc -l` ]; then
	exit 0
else
	exit 1
fi
