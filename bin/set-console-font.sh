#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# set the linux console font to something with a large number of pixels
# so that it can be read on a high resolution video display

function try {
	/bin/setfont $1
	perl -e 'foreach my $tens (1) { print ((q{ } x 99) . $tens) } print qq{\n}'
	perl -e 'foreach my $tens (1 .. 16) { print ((q{ } x 9) . ($tens % 10)) } print qq{\n}'
	perl -e 'print ((q{1234567890} x 16) . qq{\n})'
	echo $1
	echo press ^C if this font is good for you. press Enter to try a smaller font.
	read TRY
}
try /usr/share/consolefonts/Uni1-VGA32x16.psf.gz
try /usr/share/consolefonts/Uni2-Terminus32x16.psf.gz
try /usr/share/consolefonts/Uni1-VGA28x16.psf.gz
try /usr/share/consolefonts/Uni2-TerminusBold28x14.psf.gz
try /usr/share/consolefonts/Uni2-Terminus28x14.psf.gz
try /usr/share/consolefonts/Uni2-TerminusBold24x12.psf.gz
