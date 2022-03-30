#!/bin/bash
# WIP Work in progress
# a better approach than fft.pl, split types into groups of file types
# and handle them one by one.

# vim classify.sh ; ./classify.sh | grep -E \\[
# ALL="file-type-archive.lst file-type-audio.lst file-type-config.lst file-type-database.lst file-type-document.lst file-type-dumps.lst file-type-executable.lst file-type-font.lst file-type-image.lst file-type-leftovers.lst file-type-program.lst file-type-shortcut.lst"
# grep -viE 'self-extracting' file-type-archive.lst
# grep -iE 'self-extracting' $ALL

# See also classify.sh fft.pl filter-file.pl ls-types whatsin.sh filter-sounds.sh find-sounds.sh find-ez-sounds.sh

# Generate file type lists unicode, text, image, etc...
#perl -pne 's{\A.+?:\s+}{}xms' file-types.lst | sort | uniq > file-type-strings.lst
#perl -ne 'if (m{Unicode|UTF}xms && m{\s+text}xms) { print } else { print STDERR }' file-type-strings.lst > file-type-unicode-text.lst 2> file-type-nonunicode.lst
#perl -ne 'if (m{\s+text}xms && $_ !~ m{\s+image}xms) { print } else { print STDERR }' file-type-nonunicode.lst > file-type-text.lst 2> file-type-nontext.lst

perl -ne '
	BEGIN {
		open($fhExe, ">", "./file-type-executable.lst");
		open($fhProgram, ">", "./file-type-program.lst");
		open($fhAudio, ">", "./file-type-audio.lst");
		open($fhFont, ">", "./file-type-font.lst");
		open($fhDatabase, ">", "./file-type-database.lst");
		open($fhConfig, ">", "./file-type-config.lst");
		open($fhImage, ">", "./file-type-image.lst");
		open($fhArchive, ">", "./file-type-archive.lst");
		open($fhShortcut, ">", "./file-type-shortcut.lst");
		open($fhDocument, ">", "./file-type-document.lst");
		open($fhDisk, ">", "./file-type-dumps.lst");
	}
	if (m{audio|\bmidi\b|gstreamer|matroska|ogg\sdata|\basf\b|mpeg|telephony|\bwebm\b|movie|dolby|khz|macromedia\sflash|codec}xmsi)
	{
		print $fhAudio $_;
	}
	elsif (m{\bfont\b|pfm\sdata|\w+type\b|typelib}xmsi)
	{
		print $fhFont $_;
	}
	elsif (m{opendocument|gnucash|\btroff\b|sendmail|vcard\b|vcalendar|lotus\b|spreadsheet|rich\stext\sformat|htmlhelp|mailbox|e-book|\bexcel\b|powerpoint|microsoft\sword|postscript|\sdocument|ooxml|corel|message\scatalog}xmsi)
	{
		print $fhDocument $_;
	}
	elsif (m{\sprogram\b|command\sfile}xmsi)
	{
		print $fhProgram $_;
	}
	elsif (m{config\sfile|configuration\s|keystore|color\sprofile|public\skey|xauthority|\bppd\sfile|private\skey|\bxul\b|keyring|\bicc\sprofile|security|serialization|certificate|signature|\bpgp\b|\bgpg\b|property\s|authority\sdata|properties\s}xmsi)
	{
		print $fhConfig $_;
	}
	elsif (m{shortcut}xmsi)
	{
		print $fhShortcut $_;
	}
	elsif (m{archive|\brpm\b|bittorrent|\bjar\sfile|compressed\sdata|binary\spackage}xmsi)
	{
		print $fhArchive $_;
	}
	elsif (m{boot\ssector|sectors|dump\sfile|volume\sname|cache\sfile|filesystem|iso\smedia|isolinux|\bboot\b|recycle\sbin|swap\sfile}xmsi)
	{
		print $fhDisk $_;
	}
	elsif (m{\w+base|timezone\sdata|locale\sdata|Berkeley\sDB|foxpro|Git\sindex|Git\spack}xmsi)
	{
		print $fhDatabase $_;
	}
	elsif (m{executable|ooxml|relocatable|compiled|Erlang\sBEAM|dynamically\slinked|shared\sobject|\bc\slibrary|shared\slibrary|library\sfile|java\sclass\sdata|core\s+file}xmsi)
	{
		print $fhExe $_;
	}
	elsif (m{image|\briff\b|\bicon\b|bitmap|directdraw}xmsi)
	{
		print $fhImage $_;
	}
	else
	{
		print $_;
	}
	END {
		close($rhExe);
		close($rhAudio);
		close($rhImage);
		close($rhFont);
		close($rhArchive);
		close($rhShortcut);
		close($rhDocument);
		close($rhDatabase);
		close($rhProgram);
		close($rhDisk);
		close($rhConfig);
	}
' file-type-nontext.lst \
	> file-type-leftovers.lst

# parse the file type files for classification.
# TODO --legend option which tells what -le etc means....

# utf8
# utf16
# le - little endian
# be - big endian
# bom - with byte order mark
# crlf - line terminators
# crlflf - line terminators
# nolf - no line terminators
# vll - very long lines
# Parsing the text file types
perl -pne '
	chomp;
	my $TRUE = 1;
	my $q = chr(39);
	my $original = $_;
	#my $original = "";
	my @type = ();

	# Cleanups first, to remove/unify the text
	s{metric\s+data\s+\([^)]+\)}{metric data (DB...)}xms;
	s{shortcut,\s+Item\s+id\s+list\s+present,.+\z}{shortcut, ...}xms;

	s{shortcut,\s+(Item|Points|Has)\s+.*\z}{shortcut, ...}xms;
	s{(Information\s+File\s+for)\s+.+\z}{$1 D:\\PATH}xms;
	s{(Composite\s+Document\s+File\s+V2\s+Document,\s+Little\s+Endian,\s+Os):?(\s+[^,]+,).+\z}{$1:$2 MMM...}xms;
	s{(frozen)\s+(configuration)\s+-\s+(version)\s+.+\z}{$1 $2 $3 - NN}xmsg;
	s{(1st)\s+(used\s+)?(item|record)\s+"[^"]+"}{$1 $2$3 "DB..."}xmsg;
	s{(OEM-ID)\s+"[^"]+",\s+(Bytes/sector)\s+\d+.+BootSector\s+\([^)]+\)}{$1 "CC", $2 NNN...}xms;
	s{,\s+(Bytes/sector)\s+\d+.+BootSector\s+\([^)]+\)}{, $1 NNN...}xms;
	s{block\s+size\s+=\s+\d+}{block size = NNN}xms;
	s{(\d+)\s*(bit)}{$1-$2}xmsg;
	s{(\d+)\s+kbit/s}{$1 kbps}xmsg;
	s{\s+\d+\s+k?(bp)s?}{ NNN $1s}xmsg;
	s{(iterations|salt|index|size|offset|byte|flavor|length|number)\s+\d+}{$1 NN}xmsg;
	s{~\d+\s+k?(bp)s?}{~NNN $1s}xmsg;
	s{~\d+\s+(fp)s?}{~NN $1s}xmsg;
	s{\d+\.\d+\s+k?(fp)s?}{NN $1s}xmsg;
	s{\d+\s+(record)(s|\(s\))?\s+\*\s+\d+}{NN $1s * MM}xmsg;
	s{\d+\s+(plane|icon|byte|file|track|object|entrie|sample|item|message)(s|\(s\))?}{NN $1s}xmsg;
	s{(\d+|no)\s+((gmt\s+|std\s+)?(time|leap|transition|abbreviation)\s+)?(flag|time|second|char|zone|inode)(s|\(s\))?}{NN $2$5s}xmsg;
	s{(at)\s+1/\d+}{$1 1/NN}xmsg;
	s{(\d+)(\d)(\d\d)\s+Hz}{$1.$2 kHz}xmsg;
	s{sample\s+rate\s+(\d+)(\d)(\d\d)\s*}{sample rate $1.$2 kHz}xmsg;
	s{update-date:?\s+\d+-\d+-\d+}{last modified: DATE}xmsg;
	s{last\s+modified:?\s+.+?\d+:\d+:\d+\s+\d{4}}{last modified: DATE}xms;
	s{Previous\s+dump:?\s+.+?\d+:\d+:\d+\s+\d{4}}{previous dump: DATE}xms;
	s{last\s+backup:?\s+.+?\d+:\d+:\d+\s+\d{4}}{last backup: DATE}xms;
	s{This\s+dump:?\s+.+?\d+:\d+:\d+\s+\d{4}}{this dump: DATE}xms;
	s{created:?\s+.+?\d+:\d+:\d+\s+\d{4}}{created: DATE}xms;
	s{(was)\s"[^"]+(\.[^"\.]+)"}{$1 "@{[lc($2)]}"}xms;
	s{(E-book|comment:)\s"[^"]+"}{$1 "TITLE"}xms;
	s{(DBT)\s+(of)\s+.+?(\.DBF)}{$1 $2 $3}xmsg;

	if (1)
	{
		# More strict replacements when we dont care about the values
		s{\d+\s*x\s*-?\d+\s*x\s*\d+}{WxH, N-bit color}xmsg;
		s{colour}{color}xmsgi;
		s{\d+-colors}{N-bit color}xmsg;
		s{bounding\s+box\s+\[\s*0\s*,\s*0\s*\]\s*-\s*\[\d+\s*,\s*\d+\s*\]}{WxH}xmsg;
		s{\d+\s*x\s*\d+-bit}{NxM-bit}xmsg;
		s{\d+\s*x\s*\d+}{WxH}xmsg;
		s{\d+-bit}{N-bit}xmsg;
		s{(format|precision|quality)\s\d}{$1 N}xmsg;
		s{\s+\d*\.?\d+\s+kHz}{ NN kHz}xmsg;
		s{\([0-9]+\.[0-9\.]+(\s+RC\d)?\)}{(N.M)}xmsg;
		s{(SV|GSM|DB|HBCD)\s+[0-9]+\.[0-9\.]+(/[0-9]+\.[0-9\.]+)?}{$1 N.M}xmsg;
		s{(Fontographer)\s+[0-9]+(\.[0-9\.]+)?}{$1 N.M}xmsg;
		s{\s*(v)[0-9]+(\.[0-9\.]+)?}{ version N.M}xmsg;
		s{~NN}{NN}xmsg;
		s{(layer)\s+I+}{$1 I+}xmsg;
		s{MPEG(-\d)?\s+(layer)\s+\d+}{MPEG @{[lc($2)]} I+}xmsgi;
		s{(ver\.?|version|revision|standard|distribution)\s+"[0-9]+(\.[0-9\.]+)?"}{version N.M}xmsgi;
		s{(ver\.?|version|revision|standard|distribution)\s+[0-9]+(\.[0-9\.]+)?}{version N.M}xmsgi;
		s{(ver\.?|version|revision|standard|distribution)\s+\d+}{version N}xmsg;
		s{\s+\d+\.x\s+}{ version N.M }xmsg;
	}

		# strip away inconsequential info...
		#$file_info =~ s{, \s+ BuildID\[.+?(,|\z)}{,}xms;
		#$file_info =~ s{\(URL=<[^>]*>\)}{(URL=<http://www>)}xms;
		#$file_info =~ s{\A\s*}{}xms;
		#$file_info =~ s{\s*\z}{}xms;

	# BINARY file formats
	# Archive files
	my $binary;
	my $do_text = $TRUE;

	# ARCHIVE FILES
	if (m(self-extracting|archive\s+data|compressed\s+data|bittorrent|ar\s+archive|jar\s+file|binary\s+package|\brpm\b)xmsi)
	{
		$binary = $TRUE;
		$do_text = !$TRUE;
		my $archive;
		push(@type, "binary");
		push(@type, " executable") if m{self-extracting}xms;

		s{BitTorrent\s+file\s*}{}xms && push(@type, " torrent");
		s{Java\s+Jar\s+file\s+data\s*}{}xms && push(@type, " jar");
		s{\bRPM\s*}{}xms && push(@type, " rpm");
		s{debian\s+binary\s+package\s*}{}xmsi && push(@type, " deb");
		s{Microsoft\s+cabinet\s+archive\s+data\s*}{}xmsi && push(@type, " mscab");

		if (s{(\S+)\s+(compressed|archive)\s+data\s*}{}xmsi)
		{
			$archive = lc($1);
			push(@type, " $archive");
		}
		if (s{(\S+)\s+archive\s*}{}xms)
		{
			$archive = lc($1);
			push(@type, " $archive");
		}

		if (s{was\s+"\.([^"]+)"}{}xms)
		{
			push(@type, " $1.$archive");
		}
		push(@type, " archive");
	}
	# FONT FILES (before documents)
	elsif (m{
		\bfont\b|pfm\sdata|\w+type\b|typelib
		}xmsi)
	{
		$binary = $TRUE;
		$do_text = !$TRUE;
		push(@type, "binary");
		push(@type, " font");
	}
	# DOCUMENT FILES
	elsif (m{
		\w+\s*document|spreadsheet|rich\s+text|\be-?book|message\s+catalog|calendar\s+file|visiting\s+card|postscript|microsoft\s+(excel|word|powerpoint|ooxml)|gnucash|lotus|mailbox|corel|htmlhelp|[tn]roff
		}xmsi)
	{
		$binary = $TRUE;
		$do_text = !$TRUE;
		push(@type, "binary");
	#elsif (m{opendocument|gnucash|\btroff\b|sendmail|vcard\b|vcalendar|lotus\b|spreadsheet|rich\stext\sformat|htmlhelp|mailbox|e-book|\bexcel\b|powerpoint|microsoft\sword|postscript|\sdocument|ooxml|corel|message\scatalog}xmsi)

		s{(vCard\s+visiting\s+card)\s*}{}xmsi && push(@type, " contacts");
		s{(vCalendar\s+calendar\s+file)\s*}{}xmsi && push(@type, " calendar");
		s{(GNU\s+message\s+catalog|MMDF\s+mailbox)\s*}{}xmsi && push(@type, " email");
		s{(Microsoft\s+PowerPoint(\s+\d+\+?)?)\s*}{}xmsi && push(@type, " presentation");
		s{(GnuCash\s+file)\s*}{}xmsi && push(@type, " finances");
		s{(EPUB\s+document|Mobipocket\s+E-book)\s*}{}xmsi && push(@type, " textual ebook");
		s{(Lotus\s+1-2-3|Calc\s+spreadsheet|OpenDocument\s+Spreadsheet|Microsoft\s+Excel\s+\S+)\s*}{}xmsi && push(@type, " spreadsheet");
		s{(PostScript|Microsoft\s+Office\s+Word|Microsoft\s+Word(\s+\d+\+?)?|MS\s+Windows\s+HtmlHelp\s+Data|OpenDocument\s+Text(\s+Template)?|PDF\s+document|Writer\s+document|Rich\s+Text\s+Format\s+data)\s*}{}xmsi && push(@type, " textual");

		push(@type, " document");
	}

	if ($do_text)
	{
	# TEXT file formats
	if (m{ascii}xmsi)
	{
		m{non-ISO\s+extended-ascii\s+text\s*}xmsi ? push(@type, "ascii-non-iso-ext") : push(@type, "ascii")
	}
	push(@type, "iso8859") if m{iso-8859}xmsi;
	push(@type, "utf") if m{unicode|utf-}xmsi;
	push(@type, "ebcdic-intl") if m{international\s+EBCDIC}xmsi;
	s{UTF-(\d+)\s*}{}xms && push(@type, $1);
	s{Little(-|\s+)endian\s*}{}xmsi && push(@type, "-le");
	s{big(-|\s+)endian\s*}{}xmsi && push(@type, "-be");
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
	s{a\s+/usr/bin/env\s+(\S+/)?(\w+)\s+.*?\bscript\s*}{}xmsg && push(@type, " $2 script");
	s{a\s+/(opt|usr).+/(\w+)([\-0-9\.]*)\s+.*?\bscript\s*}{}xmsg && push(@type, " @{[lc($2)]} script");
	s{a\s+/(\w+)\s+script\s*}{}xmsg && push(@type, " @{[lc($1)]} script");
	s{POSIX\s+shell\s*}{}xmsg && push(@type, " shell script");
	s{Korn\s+shell\s*}{}xmsg && push(@type, " ksh script");
	s{(Tenex\s+)?C\s+shell\s*}{}xmsg && push(@type, " csh script");

	s{M4\s+macro\s+processor\s+script\s*}{}xmsg && push(@type, " m4macro script");
	s{sendmail\s+m4\s*}{}xmsg && push(@type, " m4mailmacro script");

	s{lex\s+description\s*}{}xmsg && push(@type, " lex rules");
	s{(awk)\s+script\s*}{}xmsg && push(@type, " $1 script");
	s{Bourne-Again\s+shell\s*}{}xmsg && push(@type, " bash script");
	s{(assembler|Pascal)\s+\bsource\b\s*}{}xmsg && push(@type, " @{[lc($1)]} source");
	s{C\s+source\b\s*}{}xmsg && push(@type, " c-code source");
	s{C\+\+\s+source\b\s*}{}xmsg && push(@type, " c++-code source");
	s{(automake\s+makefile)\s*}{}xmsg && push(@type, " automake");
	s{(Ruby|Perl5?)\s+module\s+source\s*}{}xmsg && push(@type, " @{[lc($1)]}module source");
	s{(makefile|Ruby|Perl5?|PHP|Python)\s*}{}xmsg && push(@type, " @{[lc($1)]}");
	s{(Node\.js)\s*}{}xmsg && push(@type, " nodejs");
	s{DOS\s+batch\s+file\s*}{}xmsg && push(@type, " dos script");
	s{OS/2\s+REXX\s+batch\s+file\s*}{}xmsg && push(@type, " rexx script");
	s{Lisp/Scheme\s+program\s*}{}xmsg && push(@type, " lisp-scheme program");

	s{(Exuberant\s+Ctags\s+tag\s+file)\s*}{}xmsg && push(@type, " ctags");

	s{magic\s+text\s+file\s+for\s+file\(1\)\s+cmd\s*}{}xmsg && push(@type, " magicfile config");

	s{(Konqueror|Web\s+browser)\s+cookie\s*}{}xmsgi && push(@type, " cookie");

	s{(MS\s+Windows\s+95\s+Internet)\s+shortcut\s+text\s+\(URL[^)]+\)\s*}{}xmsgi && push(@type, " url");

	s{(\w+)\s+(playlist)\s*}{}xmsg && push(@type, " @{[lc($2)]}");

	s{PostScript.+level\s+\d+\.\d+(,\s+type\s+EPS)?(,\s+Level\s+\d+)?\s*}{}xmsg && push(@type, " postscript document");
	s{exported\s+SGML\s+document\s*}{}xmsg && push(@type, " sgml document");
	s{HTML\s+document\s*}{}xmsg && push(@type, " html document");
	s{XML\s+.*?document\s*}{}xmsg && push(@type, " xml document");
	s{((La)?TeX|POD)\s+document\s*}{}xmsg && push(@type, " @{[lc($1)]} document");
	s{(LaTeX\s+2e)\s+document\s*}{}xmsg && push(@type, " latex document");

	s{SMTP\s+mail\s*}{}xmsg && push(@type, " email document");
	s{news\s+or\s+mail\s*}{}xmsg && push(@type, " newsmail document");

	s{GNU\s+gettext\s+message\s+catalogue\s*}{}xmsg && push(@type, " gettext document");
	s{troff\s+or\s+preprocessor\s+input\s*}{}xmsg && push(@type, " troff document");
	s{unified\s+diff\s+output\s*}{}xmsg && push(@type, " unidiff document");

	s{(X11\s+BDF)\s+font\s*}{}xmsg && push(@type, " x11-bdf font");

	s{(\bscript\b|executable)\s*}{}xmsg && push(@type, " $1");
	s{text(data|\s+file)?\s*}{}xms;
	} # $do_text

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
	file-type-document.lst \
	| sort | uniq

#	file-type-text.lst \
#	file-type-unicode-text.lst \

exit 0
Going through the file type listings and handling each.
file-types.lst
file-type-strings.lst
file-type-nontext.lst
file-type-leftovers.lst
file-type-document.lst
file-type-shortcut.lst
file-type-image.lst
file-type-audio.lst
file-type-config.lst
file-type-program.lst
file-type-executable.lst
file-type-database.lst
file-type-dumps.lst
DONE
file-type-font.lst
file-type-archive.lst
file-type-nonunicode.lst
file-type-text.lst
file-type-unicode-text.lst
