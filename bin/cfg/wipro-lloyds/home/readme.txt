Setting up git bash shell to work on C: instead of slow network share.

Git
You will need a git bash tool for your control of versions:
Install git from: 
\\Global.lloydstsb.com\file2\DML\SHARED\DigitalDevTools\Git_Git_2.8.3
If you have problem trying to clone the repositoy pao-service-stubs in your windows machine, try the following command in your Git bash:
git config --global core.longpaths true

If you find the git bash shell takes ages to start up you may want to change your home directory to C: instead of the Network share:

Go to My Computer / Properties / Environment and set HOME variable to something like C:\home after you create that directory. Copy or move your existing .bashrc and other shell configuration files from your network home drive to C:\home before starting the bash shell icon.  Important also to NOT SHARE that C:\home directory.

Change the shortcut which starts git bash to start in %HOME% dir
