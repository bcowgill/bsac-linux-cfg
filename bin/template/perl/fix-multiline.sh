#!/bin/bash
# example of multiline search and replace to fix code issues:

# for f in `git grep -lE 'extends (React\.)?Component'`; do echo $f; ./fix-multiline.sh $f; done

# Other things to fix...
# git grep TestContainer | grep import

if [ -z "$1" ]; then
	echo "
usage: $0 filename...

Perform multiple fixes to source code.

Fixes:
	Adds displayName on react components or pure render functions
	Turns anonymous test suite functions into named functions for better stack traces

Examples:

	for f in `git grep -lE 'extends (Pure|React\.)?Component'`; do echo $f; fix-multiline.sh $f; done
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
LINTFIX=0 FILENAME="$1" perl -e '
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

	if ($_ !~ m{static \s+ displayName}xms)
	{
		# class AccountDetails extends Component {
		#   static displayName = "AccountDetails";
		s{(
			(\w+) \s+ extends \s+ (Pure|React\.)?Component \s* \{ \s*?
			\n)
			(\s*)
		}{
			"$1$4static displayName = $q$2$q;\n$4"
		}xmse;

		# PageHeader.propTypes = {
		# insert it above the .propTypes declaration for pure render functions
		s{((\w+)\.propTypes\s*=\s*\{)}{$2.displayName = $q$2$q;\n\n$1}xms;

		# export const FAQComponent = props => ( or { or <
		# const mapStateToProps
		# insert it above the mapStateToProps function
		s{
			(const \s+ (\w+) \s* = \s* (?:props|\(\)) \s* => \s* [\(\{<]
				.+?
			)
			((?:export \s+ default \s+ $2|(?:export\s+)? const \s+ mapStateToProps \s* = \s*))
		}{
			"$1$2.displayName = $q$2$q;\n\n$3"
		}xmse;
	}

	# replace anonymous functions in test plans for better stack traces
	# describe("wrapStatic", (asyncDone) => {
	s{
		(
		(describe|it|before|beforeEach|after|afterEach)
		(?: \s* \. \s* (?:only|skip) \s* )?
		\( \s* ([$q$Q]) .+? \3 \s* , \s*
		)
		( \(\s* \w* \s* \) \s* ) => \s* \{
	}{$1function test@{[ucfirst($2)]}${filename}XX $4$OB}xmsg;
	my $num = 1;
	s{(function \s+ test\w+?) (XX|\d+)}{$1 . ($num++)}xmsge;

	# // NOSONAR on a single line...
	s{\n(\ |\t)*(//\s*NOSONAR\s*?\n)}{ $2}xmsg;

	if ($ENV{LINTFIX})
	{
		s{,(\s*\))}{$1}xmsg;
	}

	print $_;
' $1.bak > $1
