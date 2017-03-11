echo Manually backup some files which are important

set BACKUP=D:\d\backup
set ADMIN=root
set UNAME=velda
echo %BACKUP%

cd %BACKUP%\WD-Anywhere

copy "C:\Users\%ADMIN%\AppData\Roaming\WD\WD Anywhere Backup\*" .\%ADMIN%
copy "C:\Users\%UNAME%\AppData\Roaming\WD\WD Anywhere Backup\*" .

pause
