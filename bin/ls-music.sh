#!/bin/bash
# one liner listing of common music file properties
exiftool -ignoreMinorErrors -printFormat '$FileName $FileType $Length $FileSize $Year "$Genre" "$Artist" "$Title" "$Album" #$Track' $*
