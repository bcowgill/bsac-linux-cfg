#!/bin/bash
# svn merge conflicts with diffmerge
# http://support.sourcegear.com/viewtopic.php?f=33&t=11661

# svn diff --diff-cmd=svndiffmerge.sh filename
# Select L when you see the message below:
# Conflict discovered in 'Admin/SA_prod_edit.asp'.
# Select: (p) postpone, (df) diff-full, (e) edit,
# (mc) mine-conflict, (tc) theirs-conflict,
# (s) show all options:

# 1:-u 2:-L 3:Godel clean.launch (revision 37148) 4:-L 5:Godel clean.launch (working copy) 6:/home/brent.cowgill/workspace/trunk/.svn/pristine/63/636deeb529b7ed4699f9a20a53fec14908a24c72.svn-base 7:/home/brent.cowgill/workspace/trunk/features/com.ontologypartners.godel/Godel clean.launch 8: 9:
echo 1:$1 2:$2 3:$3 4:$4 5:$5 6:$6 7:$7 8:$8 9:$9
diffmerge -m -t1="Theirs" -t2="Merged" -t3="Mine" -r="$4" "$2" "$1" "$3"
