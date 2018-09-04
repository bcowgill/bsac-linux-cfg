# check if there are no local or staged changes in your git repo
# apart from untracked files
[ 0 == `git diff | wc -l` ] && [ 0 == `git diff --staged | wc -l` ] && exit 0
echo Aborting, there are modified files:
git status --short | head
exit 1
