# screen config file for sub project build
pushd ~/projects > /dev/null

# start detached session
screen -d -m -S subprojects
for d in core-ui files-ui groups-ui dealroom-ui new-ui
do
	pushd $d && screen -t $d bash && popd
done
popd > /dev/null
# reattach to session
screen -r subprojects
