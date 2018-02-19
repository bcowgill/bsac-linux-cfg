# check if your repo had unpushed commits
git status -b -s --porcelain | head -1 | grep '\[ahead' > /dev/null && exit 0
exit 1
