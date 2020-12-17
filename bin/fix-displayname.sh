#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# fix missing displayName on react class and pure function components.
# also fixes anonymous functions in test plans
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	echo "
usage: [LINTFIX=[01]] [ANONTESTS=[01]] $(basename $0) filename...

Perform multiple fixes to source code.

Fixes:
	Adds displayName on react components or pure render functions.
	Turns anonymous test suite functions into named functions for better stack traces. (ANONTESTS=$ANONTESTS)
	Fixes NOSONAR directives on a single line.
	Fixes lint errors around commas in function calls (LINTFIX=$LINTFIX)

Examples:

	for f in \`git grep -lE 'propTypes|defaultProps'\`; do echo \$f; $(basename $0) \$f; done
"
	exit 1
fi

if [ ! -z "$2" ]; then
	while [ ! -z $1 ]; do
		$0 "$1"
		shift
	done
	exit 0
fi

cp $1 $1.bak
LINTFIX=${LINTFIX:-0} ANONTESTS=${TESTS:-0} FILENAME="$1" perl -e '
	local $/ = undef;
	my $q = chr(39); # single quote
	my $Q = chr(34); # double quote
	my $OB = "{";

	my $filename = $ENV{FILENAME};
	$filename =~ s{\.\.?/}{}xmsg;  # bye to ./ ../
	$filename =~ s{\..+\z}{}xms; # bye to extension
	$filename =~ s{/index\z}{}xms; # strip if name is index.*
	$filename =~ s{\A .+ /}{}xms; # path is gone
	$filename = ucfirst($filename);

	$_ = <>;

	# is displayName const NOT already present?
	if ($_ =~ m{propTypes|defaultProps}xms && $_ !~ m{const \s+ displayName \s* = \s* [$q$Q]}xms)
	{
		my $displayName;
		# Check for React components as classes...
		if ($_ =~ m{extends \s+ .*Component}xms)
		{
			# TODO move propTypes defaultProps contextTypes into class as statics.

			my $has_static = 0;
			# class AccountDetails extends Component {
			#   static displayName = "AccountDetails";
			s{(
				class \s+
				(\w+) \s+ extends \s+ (Pure|React\.)?Component \s* \{ \s*?
				\n)
				(\s*)
			}{
				$has_static = 1;
				$displayName = $2;
				"const displayName = $q$2$q;\n\n$1$4static displayName = displayName;\n$4"
			}xmse;

			# PageHeader.propTypes = {
			# insert it above the .propTypes declaration for pure render functions
			s{((\w+)\.propTypes\s*=\s*\{)}{$2.displayName = displayName;\n\n$1}xms unless $has_static;

			# export const FAQComponent = props => ( or { or <
			# const mapStateToProps
			# insert it above the mapStateToProps function
			s{
				(const \s+ (\w+) \s* = \s* (?:props|\(\)) \s* => \s* [\(\{<]
					.+?
				)
				((?:export \s+ default \s+ $2|(?:export\s+)? const \s+ mapStateToProps \s* = \s*))
			}{
				"$1$2.displayName = displayName;\n\n$3"
			}xmse unless $has_static;
			}
		else
		{
			# React components as pure functions...

			# PageHeader.propTypes = {
			# insert it above the .propTypes declaration for pure render functions
			s{((\w+)\.propTypes\s*=\s*\{)}{
				$displayName = $2;
				"$2.displayName = displayName;\n\n$1"
			}xmse;

			if ($displayName)
			{
				s{((const|function) \s+ $displayName \s*)}{const displayName = $q$displayName$q;\n\n$1}xms;
			}
		}
	}

	if ($ENV{ANONTESTS})
	{
		# replace anonymous functions in test plans for better stack traces
		# describe("wrapStatic", (asyncDone) => {
		s{
			(
			(x?describe|x?it|before|beforeEach|after|afterEach)
			(?: \s* \. \s* (?:only|skip) \s* )?
			\( \s* ([$q$Q]) .+? \3 \s* , \s*
			)
			( \(\s* \w* \s* \) \s* ) => \s* \{
		}{$1function test@{[ucfirst($2)]}${filename}XX $4$OB}xmsg;
		my $num = 1;
		s{(function \s+ test\w+?) (XX|\d+)}{$1 . ($num++)}xmsge;
	}

	# // NOSONAR on a single line...
	s{\n(\ |\t)*(//\s*NOSONAR\s*?\n)}{ $2}xmsg;

	if ($ENV{LINTFIX})
	{
		s{,(\s*\))}{$1}xmsg;
	}

	print $_;
' $1.bak > $1
