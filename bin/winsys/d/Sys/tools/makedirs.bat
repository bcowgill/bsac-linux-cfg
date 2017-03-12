echo "windows - create configuration / backup directories"

set DDIR=E:
set DSYS=%DDIR%\d\Sys

echo %DSYS%

%DDIR%
cd %DSYS%

mkdir _initial-state
mkdir installed-lnk
mkdir legacy
mkdir licenses
mkdir references
mkdir snapshots
mkdir tools
mkdir troubles

mkdir ..\backup
mkdir ..\backup\to-new-computer
mkdir ..\backup\WD-Anywhere
mkdir ..\backup\WD-Anywhere\root
mkdir ..\Download
mkdir ..\Download\installed
mkdir ..\Pics
mkdir ..\Pics\_pics_jing

mkdir ..\..\NotBackedUp
