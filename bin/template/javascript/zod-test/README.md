From the Video
Fixing TypeScript's Blindspot: Runtime Typechecking
https://www.youtube.com/watch?v=rY_XqfSHock

Code: https://github.com/jherr/runtime-type...
Zod: https://github.com/colinhacks/zod
Yup: https://github.com/jquense/yup
Joi: https://joi.dev/api/?v=17.4.2

echo v17.9.1 > .nvmrc
nvm use
yarn add typescript ts-node @types/node -D
npx tsc --init  # tsconfig create for typescript
ga .nvmrc index.js package.json package-lock.json yarn.lock tsconfig.json README.md

npx ts-node index.js  # to run the file

use typescript playground

https://www.typescriptlang.org/play?


yup
joi joi-to-typescript
joy
