#!/bin/bash
# find hidden Mac files extracted from zip files.
# https://gotoes.org/sales/Zip_Mac_Files_For_PC/What_Is__MACOSX.php
find . -type d -name __MACOSX -o -name .DS_Store $*
