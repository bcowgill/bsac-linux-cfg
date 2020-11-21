
# vim classify.sh ; ./classify.sh | grep -E \\[
# See also classify.sh fft.pl filter-file.pl ls-types, whatsin.sh

# Generate file type lists unicode, text, image, etc...
#perl -pne 's{\A.+?:\s+}{}xms' file-types.lst | sort | uniq > file-type-strings.lst
#perl -ne 'if (m{Unicode|UTF}xms && m{\s+text}xms) { print } else { print STDERR }' file-type-strings.lst > file-type-unicode-text.lst 2> file-type-nonunicode.lst
perl -ne 'if (m{\s+text}xms && $_ !~ m{\s+image}xms) { print } else { print STDERR }' file-type-nonunicode.lst > file-type-text.lst 2> file-type-nontext.lst

# parse the file type files for classification.

# utf8
# utf16
# le - little endian
# bom - with byte order mark
# crlf - line terminators
# crlflf - line terminators
# nolf - no line terminators
# vll - very long lines
# Parsing the text file types
perl -pne '
	chomp;
	my $q = chr(39);
	my $original = $_;
	my @type = ();

	if (m{ascii}xmsi)
	{
		m{non-ISO\s+extended-ascii\s+text\s*}xmsi ? push(@type, "ascii-non-iso-ext") : push(@type, "ascii")
	}
	push(@type, "iso8859") if m{iso-8859}xmsi;
	push(@type, "utf") if m{unicode|utf-}xmsi;
	push(@type, "ebcdic-intl") if m{international\s+EBCDIC}xmsi;
	s{UTF-(\d+)\s*}{}xms && push(@type, $1);
	s{Little-endian\s*}{}xmsi && push(@type, "-le");
	s{big-endian\s*}{}xmsi && push(@type, "-be");
	s{\(with\s+BOM\)\s*}{}xms && push(@type, "-bom");
	s{with\s+escape\s+sequences\s*}{}xms && push(@type, "-esc");
	s{with\s+overstriking\s*}{}xms && push(@type, "-ovs");
	s{with\s+very\s+long\s+lines\s*}{}xms && push(@type, "-vll");
	s{with\s+CRLF,\s+LF\s+line\s+terminators\s*}{}xms && push(@type, "-crlflf");
	s{with\s+CRLF,\s+CR,\s+LF\s+line\s+terminators\s*}{}xms && push(@type, "-crlflfcr");
	s{with\s+CRLF,\s+CR\s+line\s+terminators\s*}{}xms && push(@type, "-crlfcr");
	s{with\s+CRLF,\s+NEL\s+line\s+terminators\s*}{}xms && push(@type, "-crlfnel");
	s{with\s+CR,\s+LF\s+line\s+terminators\s*}{}xms && push(@type, "-lfcr");
	s{with\s+LF,\s+NEL\s+line\s+terminators\s*}{}xms && push(@type, "-lfnel");
	s{with\s+CRLF\s+line\s+terminators\s*}{}xms && push(@type, "-crlf");
	s{with\s+CR\s+line\s+terminators\s*}{}xms && push(@type, "-cr");
	s{with\s+LF\s+line\s+terminators\s*}{}xms && push(@type, "-lf");
	s{with\s+NEL\s+line\s+terminators\s*}{}xms && push(@type, "-nel");
	s{with\s+no\s+line\s+terminators\s*}{}xms && push(@type, "-nolf");
	s{unicode\s+text\s*}{}xmsi;
	s{non-ISO\s+extended-ascii\s+text\s*}{}xmsi;
	s{iso-8859\s+text\s*}{}xmsi;
	s{ascii\s+text\s*}{}xmsi;
	s{international\s+ebcdic\s+text\s*}{}xmsi;

	s{Paul\s+Falstad${q}s\s+zsh\s*}{}xmsg && push(@type, " zsh script");
	s{a\s+/usr/bin/env\s+(\w+)\s*}{}xmsg && push(@type, " $1 script");
	s{a\s+/opt.+/(\w+)\s+script\s*}{}xmsg && push(@type, " $1 script");
	s{POSIX\s+shell\s*}{}xmsg && push(@type, " shell script");
	s{Korn\s+shell\s*}{}xmsg && push(@type, " ksh script");

	s{Bourne-Again\s+shell\s*}{}xmsg && push(@type, " bash script");
	s{Pascal\s+source\s*}{}xmsg && push(@type, " pascal source");
	s{C\s+source\s*}{}xmsg && push(@type, " c-code source");
	s{C\+\+\s+source\s*}{}xmsg && push(@type, " c++-code source");
	s{(automake\s+makefile)\s*}{}xmsg && push(@type, " automake");
	s{(makefile|Perl|PHP|Python)\s*}{}xmsg && push(@type, " @{[lc($1)]}");
	s{(Node\.js)\s*}{}xmsg && push(@type, " nodejs");
	s{DOS\s+batch\s+file\s*}{}xmsg && push(@type, " dos script");
	s{Lisp/Scheme\s+program\s*}{}xmsg && push(@type, " lisp-scheme program");

	s{PostScript.+level\s+\d+\.\d+(,\s+type\s+EPS)?(,\s+Level\s+\d+)?\s*}{}xmsg && push(@type, " postscript document");
	s{exported\s+SGML\s+document\s*}{}xmsg && push(@type, " sgml document");
	s{HTML\s+document\s*}{}xmsg && push(@type, " html document");
	s{XML\s+.*?document\s*}{}xmsg && push(@type, " xml document");
	s{((La)?TeX|POD)\s+document\s*}{}xmsg && push(@type, " @{[lc($1)]} document");
	s{(LaTeX\s+2e)\s+document\s*}{}xmsg && push(@type, " latex document");

	s{GNU\s+gettext\s+message\s+catalogue\s*}{}xmsg && push(@type, " gettext document");
	s{troff\s+or\s+preprocessor\s+input\s*}{}xmsg && push(@type, " troff document");
	s{unified\s+diff\s+output\s*}{}xmsg && push(@type, " unidiff document");

	s{(script|executable)\s*}{}xmsg && push(@type, " $1");
	s{text(data)?\s*}{}xms;

	s{\s+,}{}xmsg;
	s{\A\s*,\s*\z}{}xmsg;

	my $type = join("", @type);
	$type =~ s{\A\s+}{}xms;
	if ($type =~ m{\A-}xms || $_ !~ m{\A\s*\z}xms)
	{
		$_ = qq{$type: [$_] $original\n};
	}
	else
	{
		$_ = qq{$type:\n$_\n};
	}
' \
	file-type-text.lst \
	file-type-unicode-text.lst \
	| sort | uniq

exit 0
ascii bash script executable: [-l ] a /usr/bin/env bash -l script, ASCII text executable
ascii-crlf: [M3U playlist, ] M3U playlist, ASCII text, with CRLF line terminators
ascii-crlf: [PLS playlist, ] PLS playlist, ASCII text, with CRLF line terminators
ascii-crlf: [SMTP mail, ] SMTP mail, ASCII text, with CRLF line terminators
ascii executable: [a /blah ] a /blah script, ASCII text executable
ascii executable: [a /opt/customer/local/perl58/bin/perl ] a /opt/customer/local/perl58/bin/perl script, ASCII text executable
ascii executable: [a /opt/local/bin/gnuplot -persist ] a /opt/local/bin/gnuplot -persist script, ASCII text executable
ascii executable: [a /usr/bin/env ./node_modules/.bin/coffee ] a /usr/bin/env ./node_modules/.bin/coffee script, ASCII text executable
ascii executable: [a /usr/bin/spidermonkey-1.7 -s ] a /usr/bin/spidermonkey-1.7 -s script, ASCII text executable
ascii executable: [a /usr/local/bin/elixir -r ] a /usr/local/bin/elixir -r script, ASCII text executable
ascii executable: [C shell ] C shell script, ASCII text executable
ascii executable: [Korn shell ] Korn shell script, ASCII text executable
ascii executable: [Paul Falstad's zsh ] Paul Falstad's zsh script, ASCII text executable
ascii executable: [Ruby ] Ruby script, ASCII text executable
ascii executable: [Tenex C shell ] Tenex C shell script, ASCII text executable
ascii: [Exuberant Ctags tag file, ] Exuberant Ctags tag file, ASCII text
ascii: [Konqueror cookie, ] Konqueror cookie, ASCII text
ascii: [M3U playlist, ] M3U playlist, ASCII text
ascii: [news or mail, ] news or mail, ASCII text
ascii: [OS/2 REXX batch file, ] OS/2 REXX batch file, ASCII text
ascii perl: [5 module source, ] Perl5 module source, ASCII text
ascii: [Ruby module source, ] Ruby module source, ASCII text
ascii script: [awk ] awk script, ASCII text
ascii script: [lex deion, ] lex description, ASCII text
ascii script: [M4 macro processor ] M4 macro processor script, ASCII text
ascii script: [Ruby ] Ruby script, ASCII text
ascii-vll-crlf: [SMTP mail, ] SMTP mail, ASCII text, with very long lines, with CRLF line terminators
ascii-vll: [Konqueror cookie, ] Konqueror cookie, ASCII text, with very long lines
ascii-vll perl: [5 module source, ] Perl5 module source, ASCII text, with very long lines
ascii-vll script: [lex deion, ] lex description, ASCII text, with very long lines
ascii-vll script: [M4 macro processor ] M4 macro processor script, ASCII text, with very long lines
ascii-vll: [Web browser cookie, ] Web browser cookie, ASCII text, with very long lines
ascii: [X11 BDF font, ] X11 BDF font, ASCII text
ascii xdg script executable: [-open ] a /usr/bin/env xdg-open script, ASCII text executable
: [assembler source ] assembler source text
: [magic file for file(1) cmd, ] magic text file for file(1) cmd,
: [MS Windows 95 Internet shortcut (URL=< >), ] MS Windows 95 Internet shortcut text (URL=< >),
script: [lex deion ] lex description textdata
: [sendmail m4 file] sendmail m4 text file
