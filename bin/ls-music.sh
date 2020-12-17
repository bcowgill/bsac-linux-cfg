#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# one liner listing of common music file properties
exiftool -ignoreMinorErrors -printFormat '$FileName $FileType $Length $FileSize $Year "$Genre" "$Artist" "$Title" "$Album" #$Track' $*
