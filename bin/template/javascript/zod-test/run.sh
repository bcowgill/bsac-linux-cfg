node --version | grep `cat .nvmrc` \
&& npx ts-node index.ts
