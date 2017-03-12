echo Manually backup some files which are important

set DDIR=E:
set ADMIN=root
set UNAME=velda
set BACKUP=%DDIR%\d\backup

echo %BACKUP%

cd %BACKUP%\WD-Anywhere

copy "C:\Users\%ADMIN%\AppData\Roaming\WD\WD Anywhere Backup\*" .\%ADMIN%
copy "C:\Users\%UNAME%\AppData\Roaming\WD\WD Anywhere Backup\*" .

pause
