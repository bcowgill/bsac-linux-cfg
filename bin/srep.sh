#!/bin/bash
# search and replace some files, slurping the whole thing at once.

# clean up BaseComponent inheritance

# ./scripts/srep.sh `git grep -l BaseComponent | grep -vE 'README|internals/|scripts/|\.factory\.js'`
# git stash save crap | grep 'No local changes' || git stash drop; ./scripts/srep.sh `git grep -l BaseComponent | grep -vE 'README|internals/|scripts/|\.factory\.js'`; rm pause-build.timestamp

WRITE='-i.bak'
#WRITE=

touch pause-build.timestamp

perl $WRITE -Mstrict -MEnglish -e '
local $INPUT_RECORD_SEPARATOR = undef;
my $LOG_CLASS = $ENV{CMP} || "DocumentComponent";
my $DEL_DBG = 0;
my $DEL_DEL = 1;
my $DBG = "/*dbg:*/ "; # "//dbg: "
my $SKIP = 0;

my $sq = chr(39);
my $dq = chr(34);
my $obr = "{";

# insert //dbg: before any console log messages inherited from BaseComponent
sub debug {
	my ($lines) = @ARG;
	my ($pre, $prefix) = ("", "");
	if ($lines =~ s{\A(\n)}{}xms) {
		$pre = $1;
	}
	if ($lines =~ m{\A([\ \t]*)}xms) {
		$prefix = $1;
	}
	if ($lines =~ m{constructor}xms) {
		$lines = "$prefix${DBG}this.__debug(${sq}constructor$sq, { props })";
	}
	elsif ($lines =~ m{propTypes}xms) {
		$lines = "$prefix${DBG}BaseComponent.__debug(displayName, ${sq}get propTypes$sq, { class: our, types })";
	}
	elsif ($lines =~ m{defaultProps}xms) {
		$lines = "$prefix${DBG}BaseComponent.__debug(displayName, ${sq}get defaultProps$sq, { class: our, props })";
	}
	elsif ($lines =~ m{_handleMouse(\w+)}xms) {
		$lines = "$prefix${DBG}const logged = this.onMouse$1 && this.onMouse$1.apply(this, arguments)";
	}
	elsif ($lines =~ m{_handleChange}xms) {
		$lines = "$prefix${DBG}const logged = this.onChange && this.onChange.apply(this, arguments)";
	}
	elsif ($lines =~ m{_handle(Row)?Click\b}xms) {
		$lines = "$prefix${DBG}const logged = this.onClick && this.onClick.apply(this, arguments)";
	}
	elsif ($lines =~ m{
			\.(\w+)\(\) .+?
			class: \s* our \s* ,
			\s* instance: \s* this \s* ,
			\s* arguments: \s* arguments \s* \}
		}xms) {
			$lines = "$prefix${DBG}this.__debug(${sq}$1$sq, { arguments })";
	}
	else {
		$prefix = quotemeta($prefix);
#print STDERR "debug1 [$pre] [$prefix] [$lines]\n";
		$lines =~ s{((\A|\n)$prefix)}{$1$DBG}xmsg;
#print STDERR "debug2 [$pre] [$lines]\n";
		$lines =~ s{(super|BaseClass)}{BaseComponent}xmsg;
	}
	return $pre . $lines;
}

# spit out the file changes with final cleanups
sub spit {
	my ($file) = @ARG;

	# unify //dbg: /*dbg:*/
	$file =~ s{(//\s*dbg:|/\*\s*dbg:\s*\*/)}{$DBG}xmsg;

	# remove all commented out changes
	$file =~ s{ [ \t]* //del: [^\n]+ (\n|\z)}{}xmsg if $DEL_DEL;
	$file =~ s{ [ \t]* //dbg: [^\n]+ (\n|\z)}{}xmsg if $DEL_DBG;

	# log empty exceptions
	$file =~ s{
		( catch \s* \( \s* (\w+) \s* \) \s*
		\{ \s* ) (\s* \} )
	}{$1 BaseComponent.console.error(displayName, $2) $3}xmsg;

	# remove too many blank lines
	$file =~ s{\n\n+}{\n\n}xmsg;

	print $file;
}

sub ensureImports {
	my ($rFile, $package, @symbols) = @ARG;
	my $import;
	if ($$rFile !~ s{
			(import \s* \{ \s*) ([^\}]+?) (\s* \} \s* from \s* $sq$package$sq)
		}{
			my ($pre, $post) = ($1, $3);
			my @imports = @symbols;
			push(@imports, split(/\s*,\s*/, $2));
			my $temp = qq{$1, @{[join(", ", sort(@imports))]}$3};
			$temp =~ s{ (\b\w+), \s* \1 }{$1}xmsg;
			$temp =~ s[ (\{ \s*) , \s* ][$1]xmsg;
			$temp
		}xmse) {
		$import = qq{import { @{[join(", ", sort(@symbols))]} } from $sq$package$sq};
	}
	return $import;
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
	# make some changes to a specific files
	if ($class eq $LOG_CLASS) {
		$file =~ s{\.\./BaseComponent}{../LoggedComponent}xmsg;
	}

#print STDERR "[[$file]]";

	my $foundAutoBindImport = 0;
	my $foundMixinImport = 0;
	if ($file =~ m{import .+ autobind .+ from .+ core-decorators}xmsg) {
		$foundAutoBindImport = 1;
	}
	if ($file =~ m{import .+ mixin .+ from .+ core-decorators}xmsg) {
		$foundMixinImport = 1;
	}

	if (!$SKIP) {
		if ($file !~ m{BaseComponent\.mixin}xms) {
			$file =~ s{
				(class \s+ \w+ \s+ extends \s+ BaseClass)
			}{
				"\@mixin(BaseComponent.mixin(displayName, [$sq-$sq]))\n$1"
			}xmsge;
		}

#		$file =~ s{([\ \t]) _safeRender \s* \(}{$1render \(}xmsg;
		$file =~ s{
			([\ \t]*) (this\._inherits\.unshift\(displayName\))
		}{
			# "$1if (!this._inherits) { this._inherits = [] }\n$1$2"
			"$1//del: $2"
		}xmsge;
		$file =~ s{// \s* (cannot \s+ use \s+ super)}{//del: $1}xmsg;
		$file =~ s{(super\.component)}{//del: $1}xmsg;

		$file =~ s{
			([\ \t]*) (component\w+) \s* \( ([^\)]*) \) \s* \{ [\ \t]* \n (\s*)
		}{
			my $result = "$1$2 ($3) $obr\n$4${DBG}this.__debug($sq$2$sq, { $3 })\n$4";
			$result =~ s{, \s* \{ \s* \} }{}xmsg;
			$result
		}xmsge;

		$file =~ s{BaseClass \s* = \s* BaseComponent}{BaseClass = React.Component}xmsg;
# 		$file =~ s{
# 			(import \s+ BaseComponent \s+ from \s+ $sq [^$sq]+? $sq)
# 		}{
# 			my $match = $1;
# 			my $ok = ($match =~ m{from \s+ $sq\./BaseComponent}xms
# 				? $match : "const BaseComponent = React.Component");
# #print STDERR "BASE [$match] [$ok]\n";
# 			$ok
# 		}xmsge;

		# unit test inheritance fixup
		$file =~ s{
			(\.to\.be\.deep\.equal\(\[component), \s (\s*) $sq BaseComponent $sq (\]\))
		}{
			"$1$2$3"
		}xmsge;

		# convert exception log to actual console error
		# MUSTDO convert to
		# catch (exception) {
		#     this.__error(_getDocumentList, exception, { props: this.props })
		# }
		$file =~ s{
			( catch \s* \( \s* \w+ \s* \) \s*
			\{ \s* ) (?:BaseClass|BaseComponent)\.console
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

	# $file =~ s{
	# 	\n ([\ \t]*) (\@autobind) \n
	# }{\n}xmsg;
	$file =~ s{
		\n ([\ \t]*) (_handle\w+ \s* \()
	}{
		"\n$1\@autobind\n$1$2"
	}xmsge;
	$file =~ s{
		(\@autobind) \s* \1
	}{$1}xmsg;

	$file =~ s{ (this\._handle\w+) \.bind \(this\) }{$1}xmsg;
	$file =~ s{ \s* // \s+ must \s+ bind \s+ your \s+ event \s+ handlers .+? \n}{\n}xmsg;
	$file =~ s{ \s* // \s+ REFACTOR \s+ base \s+ class \s+ method \s+ to \s+ bind \s+ every \s+ _handle .+? \n}{\n}xmsg;

	if ($importAutoBind && !$foundAutoBindImport) {
		push(@imports, ensureImports(\$file, "core-decorators", qw(autobind, mixin)));
	}
	elsif (!$foundMixinImport) {
		push(@imports, ensureImports(\$file, "core-decorators", qw(mixin)));
	}

	if (!$SKIP) {
		if ($file =~ s{
				if \s* \( \s* event \s* \) \s*
				\{ \s* event\.stopPropagation\(\) \s* ;? \s* \}
			}{stopPropagation(event)}xmsg) {
			push(@imports, "import { stopPropagation } from $sq../utils/events$sq")
		}
	}

	# fix displayName + '...'
	$file =~ s{displayName \s* \+ \s* $sq([^$sq]+)$sq}{`\${displayName}$1`}xmsg;

	# inject any additional imports needed
	if (scalar(@imports)) {
	  $file =~ s{(\n\nlet \s+ our)}{"\n" . join("\n", @imports) . $1}xmse;
	}

	spit($file);
}
' $*
