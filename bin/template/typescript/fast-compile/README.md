# Fast Typescript compilation

[Article from Javascript Weekly](https://featurist.co.uk/blog/running-typescript-in-node-with-near-zero-compilation-cost/)
[Speedy Web Compiler](https://swc.rs)

npm install --save-dev @swc/core @swc/cli
curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/loader.mjs -O
curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/suppress-experimental-warnings.js -O

node --require ./suppress-experimental-warnings.js --enable-source-maps --loader ./loader.mjs my-script.ts
