#npm install -g pnpm
#pnpm install -g pnpm
date
echo Before conversion disk space used
du -sk

PROJ=`find . -name package.json \
	| grep -vE '/.(atom|n[pv]m|cache/yarn)/' \
	| grep -v /check-system/ \
	| grep -v /npmyarn/ \
	| grep -v /Atom.app/ \
	| grep -v /Library/Caches/Yarn/ \
	| grep -v node_modules \
	| perl -pne 's{/package\.json}{}xmsg'
`
for d in $PROJ
do
	if [ -d $d/node_modules ]; then
		echo $d has node_modules
		SAVE=/data/bcowgill/saved_node_modules/$d
		mkdir -p $SAVE
		pushd $d
			mv node_modules $SAVE
			pnpm install
			git add shrinkwrap.yaml
		popd
	fi
done

echo Finished conversion disk space used
du -sk
date
