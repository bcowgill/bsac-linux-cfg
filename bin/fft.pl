#!/usr/bin/env perl
# a quick attempt to filter file type info -- see classify.sh for more details
use strict;
use warnings;

sub chomper
{
	my ($line) = @_;
	chomp($line);
	return $line;
}

my @lines = map { quotemeta(chomper($_)) } grep { $_ !~ m{\A\s*\z}xms && $_ !~ m{\A\#}xms  } <DATA>;

my $regex = '^(' . join('|', @lines) . ')$';
#print "$regex\n";

while (my $file_info = <>)
{
	chomp($file_info);
	$file_info =~ s{\A.+?:\s+}{}xms;
	$file_info =~ s{, \s+ BuildID\[.+?(,|\z)}{,}xms;
	$file_info =~ s{, \s+ last\s+modified:\s+.+?(,|\z)}{,}xms;
	$file_info =~ s{(metric\s+data)\s+\([^\)]*\)}{$1 (dbDB...)}xms;
	$file_info =~ s{(length|flavor)\s+\d+}{$1 NNN}xmsg;
	$file_info =~ s{(at)\s+1/\d+}{$1 1/NNN}xmsg;
	$file_info =~ s{\d+\s+(bytes|inodes|entries|Hz|bps|track|tracks)}{NNN $1}xmsg;
	$file_info =~ s{(created:)\s+\w+\s+\w+\s+\d+\s+\d+:\d+:\d+\s+\d+}{$1 Dow Mmm D HH:MM:SS YYYY}xmsg;
	$file_info =~ s{(configuration)\s+-\s+(version)\s+.*\z}{$1 - $2 (dbDB...)}xms;
	$file_info =~ s{(directory=|icon=)[A-Z]:\\[^,]+(,|\z)}{$1D:\\PATH$2}xmsg;
	$file_info =~ s{(for)\s+[A-Z]:\\[^,]+(,)}{$1 D:\\PATH$2}xms;
	$file_info =~ s{\d+\.\d+}{N.M}xms;
	$file_info =~ s{\d+\s*x\s*\d+}{N x M}xms;
	$file_info =~ s{(version)\s+\d+}{$1 NNN}xms;


	print qq{$file_info\n} unless ($file_info =~ m{$regex});
}

__DATA__
ASCII text
ASCII text, with very long lines

UTF-8 Unicode text, with very long lines

Node.js script, ASCII text executable
C source, ASCII text
POSIX shell script, ASCII text executable

XML 1.0 document, Little-endian UTF-16 Unicode text, with CRLF, CR line terminators
XML 1.0 document, Little-endian UTF-16 Unicode text, with CRLF line terminators
XML 1.0 document, Little-endian UTF-16 Unicode text, with very long lines, with CRLF line terminators
XML 1.0 document, Little-endian UTF-16 Unicode text, with very long lines, with no line terminators
XML 1.0 document text
XML 1.0 document, UTF-8 Unicode (with BOM) text
XML 1.0 document, UTF-8 Unicode (with BOM) text, with CRLF, LF line terminators
XML 1.0 document, UTF-8 Unicode (with BOM) text, with CRLF line terminators
XML 1.0 document, UTF-8 Unicode (with BOM) text, with very long lines
XML 1.0 document, UTF-8 Unicode (with BOM) text, with very long lines, with CRLF line terminators
XML 1.0 document, UTF-8 Unicode (with BOM) text, with very long lines, with no line terminators
XML document text

XPConnect Typelib version 1.2

X pixmap image, ASCII text
X pixmap image, ASCII text, with very long lines
XV thumbnail image data

XZ compressed data
gzip compressed data
gzip compressed data, from Unix
gzip compressed data, from NTFS filesystem (NT)

YAC archive data
Zip archive data, at least vN.M to extract
ASCII text, with CRLF, CR, LF line terminators
ASCII text, with CRLF, CR, LF line terminators, with escape sequences
ASCII text, with CRLF, CR, LF line terminators, with escape sequences, with overstriking
ASCII text, with CRLF, CR line terminators
ASCII text, with CRLF, CR line terminators, with escape sequences
ASCII text, with CRLF, LF line terminators
ASCII text, with CRLF, LF line terminators, with escape sequences
ASCII text, with CR, LF line terminators
ASCII text, with CRLF line terminators
ASCII text, with CRLF line terminators, with escape sequences
ASCII text, with CRLF line terminators, with overstriking
ASCII text, with CR line terminators
ASCII text, with escape sequences
ASCII text, with no line terminators
ASCII text, with overstriking
ASCII text, with very long lines, with CRLF, CR line terminators
ASCII text, with very long lines, with CRLF, LF line terminators
ASCII text, with very long lines, with CRLF line terminators
ASCII text, with very long lines, with CR line terminators
ASCII text, with very long lines, with escape sequences
ASCII text, with very long lines, with no line terminators
assembler source text
automake makefile script, ASCII text
awk script, ASCII text
Big-endian UTF-16 Unicode text, with CRLF line terminators
Big-endian UTF-16 Unicode text, with very long lines, with no line terminators
Bourne-Again shell script, ASCII text executable
Bourne-Again shell script, ASCII text executable, with CRLF, CR, LF line terminators
Bourne-Again shell script, ASCII text executable, with CRLF line terminators
Bourne-Again shell script, ASCII text executable, with very long lines
Bourne-Again shell script, UTF-8 Unicode text executable
Bourne-Again shell script, UTF-8 Unicode text executable, with very long lines
C shell script, ASCII text executable
C++ source, ASCII text
C source, ASCII text, with CRLF, LF line terminators
C++ source, ASCII text, with CRLF, LF line terminators
C source, ASCII text, with CRLF line terminators
C++ source, ASCII text, with CRLF line terminators
C source, ASCII text, with very long lines
C++ source, ASCII text, with very long lines
C++ source, ASCII text, with very long lines, with CRLF, LF line terminators
C++ source, ASCII text, with very long lines, with CRLF line terminators
C source, ASCII text, with very long lines, with no line terminators
C source, ISO-8859 text
C++ source, ISO-8859 text
C source, Little-endian UTF-16 Unicode text, with CRLF, CR line terminators
C++ source, Non-ISO extended-ASCII text, with CRLF line terminators
C source, UTF-8 Unicode text
C++ source, UTF-8 Unicode text
C++ source, UTF-8 Unicode text, with CRLF line terminators
C source, UTF-8 Unicode text, with very long lines
C++ source, UTF-8 Unicode text, with very long lines
C source, UTF-8 Unicode text, with very long lines, with CRLF line terminators
DOS batch file, ASCII text
DOS batch file, ASCII text, with CRLF line terminators
DOS batch file, UTF-8 Unicode text
exported SGML document, ASCII text
exported SGML document, ASCII text, with CRLF, LF line terminators
exported SGML document, ASCII text, with CRLF line terminators
exported SGML document, ASCII text, with no line terminators
exported SGML document, ASCII text, with very long lines
exported SGML document, ASCII text, with very long lines, with CRLF line terminators
exported SGML document, ASCII text, with very long lines, with escape sequences
exported SGML document, ASCII text, with very long lines, with no line terminators
exported SGML document, UTF-8 Unicode text
exported SGML document, UTF-8 Unicode text, with very long lines
exported SGML document, UTF-8 Unicode text, with very long lines, with no line terminators
exported SGML document, UTF-8 Unicode (with BOM) text, with CRLF line terminators
Exuberant Ctags tag file, ASCII text
FIG image text, version N.M,
GNU gettext message catalogue, ASCII text
GNU gettext message catalogue, ISO-8859 text
GNU gettext message catalogue, Non-ISO extended-ASCII text
GNU gettext message catalogue, Non-ISO extended-ASCII text, with LF, NEL line terminators
GNU gettext message catalogue, UTF-8 Unicode text
HTML document, ASCII text
HTML document, ASCII text, with CRLF, CR line terminators
HTML document, ASCII text, with CRLF, LF line terminators
HTML document, ASCII text, with CR, LF line terminators
HTML document, ASCII text, with CRLF line terminators
HTML document, ASCII text, with CR line terminators
HTML document, ASCII text, with no line terminators
HTML document, ASCII text, with very long lines
HTML document, ASCII text, with very long lines, with CRLF, CR, LF line terminators
HTML document, ASCII text, with very long lines, with CRLF, CR line terminators
HTML document, ASCII text, with very long lines, with CRLF, LF line terminators
HTML document, ASCII text, with very long lines, with CR, LF line terminators
HTML document, ASCII text, with very long lines, with CRLF line terminators
HTML document, ASCII text, with very long lines, with CRLF line terminators, with escape sequences
HTML document, ASCII text, with very long lines, with CR line terminators
HTML document, ASCII text, with very long lines, with no line terminators
HTML document, ISO-8859 text
HTML document, ISO-8859 text, with CRLF line terminators
HTML document, ISO-8859 text, with CRLF, NEL line terminators
HTML document, ISO-8859 text, with very long lines
HTML document, ISO-8859 text, with very long lines, with CRLF, CR line terminators
HTML document, ISO-8859 text, with very long lines, with CRLF, LF line terminators
HTML document, ISO-8859 text, with very long lines, with CRLF line terminators
HTML document, ISO-8859 text, with very long lines, with no line terminators
HTML document, Little-endian UTF-16 Unicode text, with very long lines
HTML document, Non-ISO extended-ASCII text
HTML document, Non-ISO extended-ASCII text, with CRLF, LF line terminators
HTML document, Non-ISO extended-ASCII text, with CRLF line terminators
HTML document, Non-ISO extended-ASCII text, with CRLF, NEL line terminators
HTML document, Non-ISO extended-ASCII text, with very long lines
HTML document, Non-ISO extended-ASCII text, with very long lines, with CRLF, CR line terminators
HTML document, Non-ISO extended-ASCII text, with very long lines, with CRLF, LF line terminators
HTML document, Non-ISO extended-ASCII text, with very long lines, with CRLF line terminators
HTML document, Non-ISO extended-ASCII text, with very long lines, with CRLF, NEL line terminators
HTML document, Non-ISO extended-ASCII text, with very long lines, with no line terminators
HTML document, UTF-8 Unicode text
HTML document, UTF-8 Unicode text, with CRLF, LF line terminators
HTML document, UTF-8 Unicode text, with CRLF line terminators
HTML document, UTF-8 Unicode text, with very long lines
HTML document, UTF-8 Unicode text, with very long lines, with CRLF, CR line terminators
HTML document, UTF-8 Unicode text, with very long lines, with CRLF, LF line terminators
HTML document, UTF-8 Unicode text, with very long lines, with CRLF line terminators
HTML document, UTF-8 Unicode text, with very long lines, with no line terminators
HTML document, UTF-8 Unicode (with BOM) text
HTML document, UTF-8 Unicode (with BOM) text, with CRLF line terminators
HTML document, UTF-8 Unicode (with BOM) text, with very long lines
HTML document, UTF-8 Unicode (with BOM) text, with very long lines, with CRLF, CR, LF line terminators
HTML document, UTF-8 Unicode (with BOM) text, with very long lines, with CRLF line terminators
International EBCDIC text, with NEL line terminators
ISO-8859 text
ISO-8859 text, with CRLF line terminators
ISO-8859 text, with no line terminators
ISO-8859 text, with no line terminators, with escape sequences
ISO-8859 text, with no line terminators, with escape sequences, with overstriking
ISO-8859 text, with very long lines
ISO-8859 text, with very long lines, with CRLF line terminators
ISO-8859 text, with very long lines, with no line terminators
Konqueror cookie, ASCII text
Konqueror cookie, ASCII text, with very long lines
Korn shell script, ASCII text executable
LaTeX 2e document, ASCII text
LaTeX document, ASCII text
lex description, ASCII text
lex description, ASCII text, with very long lines
lex description textdata
Lisp/Scheme program, ASCII text
Lisp/Scheme program, ASCII text, with CR, LF line terminators
Lisp/Scheme program, ASCII text, with very long lines
Lisp/Scheme program, ASCII text, with very long lines, with CR, LF line terminators
Lisp/Scheme program, ASCII text, with very long lines, with no line terminators
Lisp/Scheme program, ISO-8859 text
Lisp/Scheme program, Non-ISO extended-ASCII text
Lisp/Scheme program, UTF-8 Unicode text
Lisp/Scheme program, UTF-8 Unicode text, with CRLF line terminators
Lisp/Scheme program, UTF-8 Unicode text, with very long lines
Little-endian UTF-16 Unicode text
Little-endian UTF-16 Unicode text, with CRLF, CR line terminators
Little-endian UTF-16 Unicode text, with CRLF, LF line terminators
Little-endian UTF-16 Unicode text, with CRLF line terminators
Little-endian UTF-16 Unicode text, with CR line terminators
Little-endian UTF-16 Unicode text, with no line terminators
Little-endian UTF-16 Unicode text, with very long lines, with CRLF, CR line terminators
Little-endian UTF-16 Unicode text, with very long lines, with CRLF line terminators
Little-endian UTF-16 Unicode text, with very long lines, with CRLF line terminators, with escape sequences
Little-endian UTF-16 Unicode text, with very long lines, with no line terminators
M3U playlist, ASCII text
M3U playlist, ASCII text, with CRLF line terminators
M4 macro processor script, ASCII text
M4 macro processor script, ASCII text, with very long lines
magic text file for file(1) cmd,
makefile script, ASCII text
makefile script, ASCII text, with escape sequences
makefile script, ASCII text, with very long lines
makefile script, ISO-8859 text
makefile script, ISO-8859 text, with very long lines
makefile script, UTF-8 Unicode text
MS Windows 95 Internet shortcut text (URL=< >),
Netpbm PBM image text, size = N x M,
Netpbm PGM image text, size = N x M,
Netpbm PPM image text Netpbm PPM image text, size = N x M,
news or mail, ASCII text
Node.js script, ASCII text executable, with CRLF line terminators
Node.js script, ASCII text executable, with very long lines
Node.js script, UTF-8 Unicode text executable
Node.js script, UTF-8 Unicode text executable, with CRLF, LF line terminators
Node.js script, UTF-8 Unicode text executable, with very long lines
Non-ISO extended-ASCII text
Non-ISO extended-ASCII text, with CRLF line terminators
Non-ISO extended-ASCII text, with no line terminators, with overstriking
Non-ISO extended-ASCII text, with very long lines
Non-ISO extended-ASCII text, with very long lines, with CRLF line terminators
Non-ISO extended-ASCII text, with very long lines, with CRLF, NEL line terminators
Non-ISO extended-ASCII text, with very long lines, with LF, NEL line terminators
Non-ISO extended-ASCII text, with very long lines, with no line terminators
OS/2 REXX batch file, ASCII text
Pascal source, ASCII text
Pascal source, ASCII text, with CRLF line terminators
Pascal source, ASCII text, with no line terminators
Pascal source, ASCII text, with very long lines
Pascal source, ASCII text, with very long lines, with CRLF line terminators
Pascal source, ASCII text, with very long lines, with no line terminators
Pascal source, ISO-8859 text
Pascal source, UTF-8 Unicode text
Pascal source, UTF-8 Unicode text, with CRLF line terminators
Pascal source, UTF-8 Unicode text, with very long lines
Pascal source, UTF-8 Unicode text, with very long lines, with no line terminators
Pascal source, UTF-8 Unicode (with BOM) text
Pascal source, UTF-8 Unicode (with BOM) text, with very long lines
Paul Falstad's zsh script, ASCII text executable
Perl5 module source, ASCII text
Perl5 module source, ASCII text, with very long lines
Perl POD document, ASCII text, with very long lines
Perl script, ASCII text executable
Perl script, ASCII text executable, with CRLF line terminators
Perl script, ASCII text executable, with very long lines
Perl script, ASCII text executable, with very long lines, with CR line terminators
Perl script, ISO-8859 text executable
Perl script, UTF-8 Unicode text executable
Perl script, UTF-8 Unicode text executable, with CRLF line terminators
PHP script, ASCII text
PHP script, ASCII text, with CRLF line terminators
PHP script, ASCII text, with very long lines
PHP script, UTF-8 Unicode text
PLS playlist, ASCII text, with CRLF line terminators
POSIX shell script, ASCII text executable, with escape sequences
POSIX shell script, ASCII text executable, with very long lines
POSIX shell script, UTF-8 Unicode text executable
POSIX shell script, UTF-8 Unicode text executable, with very long lines
PostScript document text conforming DSC level N.M
PostScript document text conforming DSC level N.M, Level 1
PostScript document text conforming DSC level N.M, Level 2
PostScript document text conforming DSC level N.M, type EPS, Level 1
Python script, ASCII text executable
Python script, ASCII text executable, with very long lines
Python script, ASCII text executable, with very long lines, with CRLF, LF line terminators
Python script, ASCII text executable, with very long lines, with no line terminators
Python script, UTF-8 Unicode text executable
Python script, UTF-8 Unicode text executable, with CRLF, LF line terminators
Python script, UTF-8 Unicode text executable, with very long lines
Ruby module source, ASCII text
Ruby script, ASCII text
Ruby script, ASCII text executable
sendmail m4 text file
SMTP mail, ASCII text, with CRLF line terminators
SMTP mail, ASCII text, with very long lines, with CRLF line terminators
Tenex C shell script, ASCII text executable
TeX document, ASCII text
TeX document, ASCII text, with very long lines
troff or preprocessor input, ASCII text
troff or preprocessor input, ASCII text, with very long lines
troff or preprocessor input textdata
troff or preprocessor input, UTF-8 Unicode text
troff or preprocessor input, UTF-8 Unicode text, with very long lines
troff or preprocessor input, UTF-8 Unicode (with BOM) text
Unicode text, UTF-32, big-endian
Unicode text, UTF-32, little-endian
unified diff output, ASCII text
unified diff output, ISO-8859 text
unified diff output, ISO-8859 text, with very long lines
unified diff output, UTF-8 Unicode text
UTF-8 Unicode text
UTF-8 Unicode text, with CRLF, CR, LF line terminators, with escape sequences
UTF-8 Unicode text, with CRLF, LF line terminators
UTF-8 Unicode text, with CRLF, LF line terminators, with escape sequences, with overstriking
UTF-8 Unicode text, with CR, LF line terminators
UTF-8 Unicode text, with CRLF line terminators
UTF-8 Unicode text, with CR, LF line terminators, with escape sequences
UTF-8 Unicode text, with escape sequences
UTF-8 Unicode text, with LF, NEL line terminators
UTF-8 Unicode text, with no line terminators
UTF-8 Unicode text, with overstriking
UTF-8 Unicode text, with very long lines, with CRLF, CR, LF line terminators, with escape sequences, with overstriking
UTF-8 Unicode text, with very long lines, with CRLF, LF line terminators
UTF-8 Unicode text, with very long lines, with CR, LF line terminators
UTF-8 Unicode text, with very long lines, with CRLF line terminators
UTF-8 Unicode text, with very long lines, with escape sequences
UTF-8 Unicode text, with very long lines, with LF, NEL line terminators
UTF-8 Unicode text, with very long lines, with LF, NEL line terminators, with escape sequences
UTF-8 Unicode text, with very long lines, with NEL line terminators, with escape sequences
UTF-8 Unicode text, with very long lines, with no line terminators
UTF-8 Unicode text, with very long lines, with no line terminators, with escape sequences
UTF-8 Unicode (with BOM) text
UTF-8 Unicode (with BOM) text, with CRLF line terminators
UTF-8 Unicode (with BOM) text, with no line terminators
UTF-8 Unicode (with BOM) text, with very long lines
UTF-8 Unicode (with BOM) text, with very long lines, with CRLF line terminators
UTF-8 Unicode (with BOM) text, with very long lines, with escape sequences
UTF-8 Unicode (with BOM) text, with very long lines, with no line terminators
Web browser cookie, ASCII text, with very long lines
X11 BDF font, ASCII text
XML N.M document, Little-endian UTF-16 Unicode text, with CRLF, CR line terminators
XML N.M document, Little-endian UTF-16 Unicode text, with CRLF line terminators
XML N.M document, Little-endian UTF-16 Unicode text, with very long lines, with CRLF line terminators
XML N.M document, Little-endian UTF-16 Unicode text, with very long lines, with no line terminators
XML N.M document text
XML N.M document, UTF-8 Unicode (with BOM) text
XML N.M document, UTF-8 Unicode (with BOM) text, with CRLF, LF line terminators
XML N.M document, UTF-8 Unicode (with BOM) text, with CRLF line terminators
XML N.M document, UTF-8 Unicode (with BOM) text, with very long lines
XML N.M document, UTF-8 Unicode (with BOM) text, with very long lines, with CRLF line terminators
XML N.M document, UTF-8 Unicode (with BOM) text, with very long lines, with no line terminators
