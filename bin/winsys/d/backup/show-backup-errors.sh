#!/bin/bash
echo Searching backup log for error messages:
perl -ne '
	$print = 0;
	++$print if m{ Backing \s+ up}xms;
	++$print if m{ \s /cygdrive/[cde]/d/backup}xms;
	++$print if m{ (error|warn|tar): }xmsi;
	print if $print;
' backup.log
