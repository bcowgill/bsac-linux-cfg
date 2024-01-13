if node --version | grep `cat .nvmrc`; then
	npm run format
	# checking structure of fromZodError return
#	npx ts-node index.ts
	npx ts-node index.ajv.ts
#	node index.ajv.js
else
	echo "You need to run: nvm use"
	echo "to set the correct version of node [`cat .nvmrc`] for this project."
fi
