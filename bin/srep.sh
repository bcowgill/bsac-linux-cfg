#!/bin/bash
# search and replace some files, slurping the whole thing at once.

# clean up BaseComponent inheritance

# ./scripts/srep.sh `git grep -l BaseComponent | grep -vE 'README|internals/|scripts/'`
# git stash save crap | grep 'No local changes' || git stash drop; ./scripts/srep.sh `git grep -l BaseComponent | grep -vE 'README|internals/|scripts/'`; rm pause-build.timestamp

WRITE='-i.bak'
#WRITE=

touch pause-build.timestamp

perl $WRITE -Mstrict -MEnglish -e '
local $INPUT_RECORD_SEPARATOR = undef;
my $sq = chr(39);
my $dq = chr(34);
my $DEL = 1;
my $SKIP = 0;

# insert //dbg: before any console log messages inherited from BaseComponent
sub debug {
	my ($lines) = @ARG;
	my ($pre, $prefix) = ("", "");
	if ($lines =~ s{\A(\n)}{}xms) {
		$pre = $1;
	}
	if ($lines =~ m{\A([\ \t]*)}xms) {
		$prefix = quotemeta($1);
	}
#print STDERR "debug1 [$pre] [$prefix] [$lines]\n";
	$lines =~ s{((\A|\n)$prefix)}{$1//dbg: }xmsg;
#print STDERR "debug2 [$pre] [$lines]\n";
	return $pre . $lines;
}

# spit out the file changes with final cleanups
sub spit {
	my ($file) = @ARG;

	# remove all commented out changes
	$file =~ s{ [ \t]* //(del|dbg): [^\n]+ (\n|\z)}{}xmsg if $DEL;

	# log empty exceptions
	$file =~ s{
		( catch \s* \( \s* (\w+) \s* \) \s*
		\{ \s* ) (\s* \} )
	}{$1 BaseClass.console.error(displayName, $2) $3}xmsg;

	# remove too many blank lines
	$file =~ s{\n\n+}{\n\n}xmsg;

	print $file;
}

while (my $file = <>) {
	my @imports = ();

	# identify which file we are to disable rules in some cases
	$file =~ m{class \s+ (\w+) \s+ extends \s+ BaseClass}xms;
	my $class = $1 || "";

	# make no changes to certain files
	if ($class eq "EmptyComponent") {
		spit($file);
		next;
	}

#print STDERR "[[$file]]";

   my $foundAutoBindImport = 0;
   if ($file =~ m{import .+ autobind .+ from .+ core-decorators}xmsg) {
		$foundAutoBindImport = 1;
   }

	if (!$SKIP) {
		$file =~ s{([\ \t]) _safeRender \s* \(}{$1render \(}xmsg;
		$file =~ s{
			([\ \t]*) (this\._inherits\.unshift\(displayName\))
		}{
			"$1if (!this._inherits) { this._inherits = [] }\n$1$2"
			# "$1//del: $2"
		}xmsge;
		$file =~ s{// \s* (cannot \s+ use \s+ super)}{//del: $1}xmsg;
		$file =~ s{(super\.component)}{//del: $1}xmsg;

		$file =~ s{
			(import \s+ BaseComponent \s+ from \s+ $sq [^$sq]+? $sq)
		}{
			my $match = $1;
			my $ok = ($match =~ m{from \s+ $sq\./BaseComponent}xms
				? $match : "const BaseComponent = React.Component");
#print STDERR "BASE [$match] [$ok]\n";
			$ok
		}xmsge;

		# unit test inheritance fixup
		$file =~ s{
			(\.to\.be\.deep\.equal\(\[component), \s (\s*) $sq BaseComponent $sq (\]\))
		}{
			"$1$2$3"
		}xmsge;

		# convert exception log
		$file =~ s{
			( catch \s* \( \s* \w+ \s* \) \s*
			\{ \s* ) BaseClass\.console
		}{$1console}xmsg;

		# suppress base class logging
		$file =~ s{
			( (\A|\n) [\ \t]* (BaseClass|super)\.console\.\w+ \( .+? (\}|, \s* exception)\) )
		}{
			debug($1)
		}xmsge;
	}

	# add @autobind to any _handle functions
	my $importAutoBind = 0;
	$file =~ s{
		\n [\ \t]* (this\._handle\w+) \s* = \s* \1 \.bind \(this\);? [\ \t]*
	}{
		$importAutoBind = 1;
		""
	}xmsge;

	$file =~ s{
		\n ([\ \t]*) (\@autobind) \n
	}{\n}xmsg;
	$file =~ s{
		\n ([\ \t]*) (_handle\w+ \s* \()
	}{
		"\n$1\@autobind\n$1$2"
	}xmsge;

	$file =~ s{ (this\._handle\w+) \.bind \(this\) }{$1}xmsg;
	$file =~ s{ \s* // \s+ must \s+ bind \s+ your \s+ event \s+ handlers .+? \n}{\n}xmsg;
	$file =~ s{ \s* // \s+ REFACTOR \s+ base \s+ class \s+ method \s+ to \s+ bind \s+ every \s+ _handle .+? \n}{\n}xmsg;

	if ($importAutoBind && !$foundAutoBindImport) {
		push(@imports, "import { autobind } from ${sq}core-decorators$sq")
	}

	if (!$SKIP) {
		if ($file =~ s{
				if \s* \( \s* event \s* \) \s*
				\{ \s* event\.stopPropagation\(\) \s* ;? \s* \}
			}{stopPropagation(event)}xmsg) {
			push(@imports, "import { stopPropagation } from $sq../utils/events$sq")
		}
	}

	# inject any additional imports needed
	if (scalar(@imports)) {
	  $file =~ s{(\n\nlet \s+ our)}{"\n" . join("\n", @imports) . $1}xmse;
	}

	spit($file);
}
' $*
