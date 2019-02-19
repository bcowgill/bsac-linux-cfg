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
