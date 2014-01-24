#!/bin/bash
# svn diff script for diffmerge
# svn diff --diff-cmd=svndiffmerge.sh filename
# http://support.sourcegear.com/viewtopic.php?f=33&t=11661
# 1:-u 2:-L 3:Godel clean.launch (revision 37148) 4:-L 5:Godel clean.launch (working copy) 6:/home/brent.cowgill/workspace/trunk/.svn/pristine/63/636deeb529b7ed4699f9a20a53fec14908a24c72.svn-base 7:/home/brent.cowgill/workspace/trunk/features/com.ontologypartners.godel/Godel clean.launch 8: 9:
#echo 1:$1 2:$2 3:$3 4:$4 5:$5 6:$6 7:$7 8:$8 9:$9
diffmerge --nosplash -u -t1="$3" -t2="$5" "$6" "$7"
