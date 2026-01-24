echo lsb_release -a:
lsb_release -a
echo " "
echo uname -a:
uname -a
echo " "
echo hostnamectl
hostnamectl

echo " "
echo /etc/issue:
cat /etc/issue
echo " "
echo /etc/os-release:
cat /etc/os-release
echo " "
echo /etc/lsb-release:
cat /etc/lsb-release
