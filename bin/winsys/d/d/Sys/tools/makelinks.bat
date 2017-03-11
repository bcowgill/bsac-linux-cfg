
set DD=E:
set USER=adlev
set SIM=velda
set EMPROFILE=z6uzyt6u.default
set EMLEGACY=xu8pdynm.default

D:
CD \
MKLINK /J d %DD%\d

C:
CD \
MKLINK /J d %DD%\d

CD \Users
MKLINK /J %SIM% %USER%

CD \cygwin\home
MKLINK /J %SIM% %USER%

CD \Users\velda\AppData\Roaming\Thunderbird\Profiles
MKLINK /J %EMLEGACY% %EMPROFILE%
CD "\Documents and Settings"
MKLINK /J %SIM% %USER%

