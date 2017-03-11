package BSAC::FileTypes;
my $CLASS = "BSAC::FileTypes";

{ use 5.006; }
use strict;
use warnings;
use Carp;
use English -no_match_vars;
use Data::Dumper;

our $VERSION = '1.00';

require Exporter;
our @ISA = ('Exporter');
our @EXPORT = qw();
our @EXPORT_OK = qw(check_path);
our @EXPORT_FAIL = qw();

my %FileTypes = (
	'documents' => [qw(doc docx dot dotm dotx xls xlsx xltx ppt ppd pptx odf odt ods odp rtf pdf eps ps)],
	'text' => [qw(txt utf8 utf-8 utxt md)],
	'scripts' => [qw(sh tcsh csh bsh bash zsh vsh fish bat pl pm php tcl sed awk py rb)],
	'source' => [qw(java cpp c)],
	'web' => [qw(js json jsx html htm css scss sass)],
	'config' => [qw(xml yml yaml cfg conf config)],
	'winconfig' => [qw(ini xml reg)],
	'link' => [qw(url lnk)],
	'fonts' => [qw(ttf woff woff2 fon fnt)],
	'drawing' => [qw(svg dia)],
	'images' => [qw(jpg jpeg gif png mpg ico bmp)],
	'rimages' => [qw(tif tiff tga psd ocx ocr flg)], # rarer image types
	'ximages' => [qw(xpt xpm xpi pnm)],
	'audio' => [qw(wav mp3 ogg wma mid m4a fla)],
	'video' => [qw(mov avi mp4 wmv swf)],
	'archive' => [qw(zip tar tgz tar.gz gz 7z jar war cab ar)],
);

my %FileTypeRegex;

sub init {
	%FileTypeRegex = map {
		($ARG, list_to_regex($FileTypes{$ARG}))
	} keys(%FileTypes);
}

sub check_path {
	my ($path, $rhCounts) = @ARG;
	$rhCounts ||= {};
	my @Types = grep {
		$path =~ $FileTypeRegex{$ARG}
	} keys(%FileTypeRegex);
	return count_matches($path, \@Types, $rhCounts);
}

sub count_matches {
	my ($path, $raTypes, $rhCounts) = @ARG;
	$path =~ s{/([^/]+)\z}{/}xms;
	my $file = $1;
	foreach my $type (@$raTypes) {
		push(@{$rhCounts->{$path}{$type}}, $file);
	}
	return @$raTypes;
}

sub list_to_regex {
	my $raList = shift;
	my $regex = list_to_regex_string($raList);
	return qr{$regex}xmsi;
}

sub list_to_regex_string {
	my $raList = shift;
	return '\.(' . join('|', map { quotemeta($ARG) } @$raList) . ')\z';
}

sub trace {
	print Dumper(\@ARG);
	return @ARG
}

init();

1;
