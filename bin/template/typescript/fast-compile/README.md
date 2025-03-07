# Fast Typescript compilation

TODO
[Modernizr to detect browser features](http://html5doctor.com/using-modernizr-to-detect-html5-features-and-provide-fallbacks/#:~:text=Modernizr%20is%20a%20JavaScript%20library,that%20do%20not%20support%20them.)
MUSTDO retry again after jest works with typescript 5

[Article from Javascript Weekly](https://featurist.co.uk/blog/running-typescript-in-node-with-near-zero-compilation-cost/)
[Speedy Web Compiler](https://swc.rs)
[Typescript](https://www.typescriptlang.org)

npm install --save-dev @swc/core @swc/cli typescript typescript@beta
curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/loader.mjs -O
curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/suppress-experimental-warnings.js -O

node --require ./suppress-experimental-warnings.js --enable-source-maps --loader ./loader.mjs my-script.ts

Then add eslint

https://typescript-eslint.io/getting-started
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint eslint-plugin-import

Then add prettier

https://blog.logrocket.com/linting-typescript-eslint-prettier/

npm install --save-dev prettier eslint-config-prettier

Then added a unit test with node assert and ran manually

TODO install jest -- ts-jest

Neither of these worked with typescript 5 yet so cannot try it at this time.

https://jestjs.io/docs/getting-started

with babel for typescript transpilation -- not v5 yet.
npm install --save-dev babel-jest @babel/core @babel/preset-env @babel/preset-typescript jest

with ts-jest -- also not v5 support yet
npm install --save-dev ts-jest @jest/globals [or @types/jest]

# Result of test:

npm run compile gives:

real 3.55
user 7.24
sys 0.39

10s+

npm run fast gives:

real 0.09
user 0.07
sys 0.02

<0.2s

50x faster to run without type checking!
