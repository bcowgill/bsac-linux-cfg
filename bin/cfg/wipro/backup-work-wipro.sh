pushd ~/bin > /dev/null

BK=~/cloud/bk
BIN=./wipro

crontab -l > ~/bin/cfg/wipro/crontab-$HOSTNAME

mkdir -p $BK
cp ~/workspace/000_scratch.txt $BK 
cp ~/workspace/projects/allianz/personal-assistant-app/review-notes.txt $BK
