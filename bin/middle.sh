#!/bin/bash
# grep a file for a section marked by an open and close marker
# i.e. #WORKSPACEDEF ... #/WORKSPACEDEF
# middle.sh '#WORKSPACEDEF' '#/WORKSPACEDEF' filename

export START=$1
shift
export END=$1
shift
#echo $START to $END
#echo $*

perl -ne '
if (m{$ENV{START}}) { $print = 1; };
print if $print;
if (m{$ENV{END}}) {$print = 0; };
' $*
