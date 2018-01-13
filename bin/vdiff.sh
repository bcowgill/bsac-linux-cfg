if which diffmerge > /dev/null; then
	diffmerge --nosplash $*
else
	if which diffmerge.sh > /dev/null; then
		diffmerge.sh $*
	fi
fi
