# bash functions
# Brent S.A. Cowgill

# show whichever command something is, a program, alias or shell function.
whichever () {
	local cmd
	cmd=$1
	which $cmd 2> /dev/null
	alias | grep "alias $cmd="
	command -V $cmd
}

git_current_branch ()
{
    local ref;
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref=$(git rev-parse --short HEAD 2> /dev/null) || return;
    echo ${ref#refs/heads/}
}
