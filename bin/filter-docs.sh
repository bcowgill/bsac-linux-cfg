#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
GREP="egrep -i"

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--regex] [--help|--man|-?]

This will filter a list of file names looking for application document file extensions.

--regex Shows the regex used for matching document file extensions.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.


See also filter-docs.sh, filter-zips.sh, filter-fonts.sh, filter-scripts.sh, filter-web.sh, filter-css.sh, filter-videos.sh, filter-images.sh, filter-sounds.sh, classify.sh

See the online file extension database https://fileinfo.com/extension/pdf

Example:

locate -i budget | $cmd
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ "$1" == "--regex" ]; then
	GREP="echo"
fi

$GREP '\.(docx?|dot[mx]?|eps|od[cfistp]|otc|vor|sx[cdiw]|sd[abcdmpsw]|st[cdiw]|pdf|pp([dt]|tx)|ps|rtf|xlsx?|xltx|eco|eml|cal)(:|"|\s*$)' $* # .odf .ods .odt .odp .odi .odc .ppd .ppt .pptx .eco .eml .cal .vor .sxc .sxd .sxi .sxw .sda .sdb .sdc .sdd .sdp .sds .sdw .stc .std .sti .stw .sdm
