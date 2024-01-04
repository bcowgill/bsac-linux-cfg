MUSTDO
 - AJV is more popular?  https://github.com/ajv-validator/ajv  The fastest JSON schema Validator.
   - https://ajv.js.org/guide/getting-started.html
   - You can try Ajv without installing it in the Node.js REPL: https://runkit.com/npm/ajv
 - logSchemaOnce to report a given schema error only once, like react property errors (dev only builds)
 - zodNew() construct a new object based on the schema?
 - dev only validation function which turns off in prod, like react prop-types
 - generate random test data from schema?
 - check out @hapi/joi web framework.

From the Video
Fixing TypeScript's Blindspot: Runtime Typechecking
https://www.youtube.com/watch?v=rY_XqfSHock

Code: https://github.com/jherr/runtime-type...
Zod: https://github.com/colinhacks/zod
     https://github.com/causaly/zod-validation-error
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

Schema definitions are required by default, must use .optional() to mark them optional vs Yup library where they are optional by default. (like React)

ZodError details https://github.com/colinhacks/zod/blob/master/ERROR_HANDLING.md
validator - library of additional string validation functions
zod-validation-error - more useful ZodError messages
yup
joi joi-to-typescript
joy

-----
npm install --save-dev prettier ajv

npm WARN config init.author.name Use `--init-author-name` instead.
npm WARN config init.author.email Use `--init-author-email` instead.
npm WARN config init.author.url Use `--init-author-url` instead.

added 8 packages, changed 11 packages, and audited 44 packages in 7s

5 packages are looking for funding
  run `npm fund` for details

1 low severity vulnerability

To address all issues, run:
  npm audit fix

Run `npm audit` for details.
