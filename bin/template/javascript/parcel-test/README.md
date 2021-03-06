Testing the parcel bundler for plan js, node, react, etc
https://medium.freecodecamp.org/all-you-need-to-know-about-parcel-dbe151b70082

To use with pnpm just pnpm install should use package.json and shrinkwrap.yml files to set up your node_modules.

To use with yarn, remove shrinkwrap.yml and cp yarn/package.json to package.json and yarn/yarn.lock to ./yarn.lock then yarn install should use yarn.lock to set up your node_modules.

# does not work well with node v6.x
nvm use 8.6.0
git init
pnpm init
pnpm install --save-dev parcel-bundler rimraf node-sass
+ node-sass 4.9.0
+ parcel-bundler 1.9.1
+ rimraf 2.6.2

# for react
pnpm install --save-dev react react-dom fbjs prop-types object-assign babel-core babel-preset-env babel-plugin-add-module-exports babel-plugin-transform-export-extensions babel-plugin-transform-class-properties babel-plugin-transform-exponentiation-operator babel-plugin-transform-object-rest-spread babel-preset-react react-style-proptype
echo '{ "presets": [ "env", "react" ] }' > .babelrc
transform add module exports may be unneeded.
+ babel-core 6.26.3
+ babel-preset-env 1.7.0
+ babel-preset-react 6.24.1
+ babel-plugin-add-module-exports 0.2.1
+ babel-plugin-transform-export-extensions 6.22.0
+ babel-plugin-transform-class-properties 6.24.1
+ babel-plugin-transform-exponentiation-operator 6.24.1
+ babel-plugin-transform-object-rest-spread 6.26.0
+ fbjs 0.8.17
+ object-assign 4.1.1
+ prop-types 15.6.1
+ react 16.4.1
+ react-dom 16.4.1
+ react-style-proptype 3.2.1

# for vue
pnpm install --save-dev vue vue-template-compiler vue-hot-reload-api ansi-styles@3.2.1 @vue/component-compiler-utils
+ @vue/component-compiler-utils 2.0.0
+ vue 2.5.16
+ vue-hot-reload-api 2.3.0
+ vue-template-compiler 2.5.16
+ ansi-styles 3.2.1

# for typescript
pnpm install --savea-dev typescript
+ typescript 2.9.2


# for Benchmark
pnpm install --save-dev microtimer benchmark lodash platform
+ benchmark 2.1.4
+ lodash 4.17.10
+ microtimer 1.1.0
+ platform 1.3.5

TODO consider reporting to parcel team.
got this working for node and a build target for the browser but have to fix things up with a post-build script as parcel screws things up.
cannot run a dev build of benchmark for the same reason.  Also found sometimes parcel gets confused and need to delete its .cache

FAILED: start:react target stopped working loading prop-types module for development mode.
# for using appropriate polyfills based on target environment
pnpm install babel-polyfill --save-dev
and adjust .babelrc accordingly
useBuiltIns: true
debug:true
and import babel-polyfill once only in your project.
+ babel-polyfill 6.26.0

# for jest and enzyme unit testing and coverage
pnpm install jest babel-jest jest-environment-jsdom weak react-test-renderer enzyme --save-dev
+ jest 23.2.0
+ babel-jest 23.2.0
+ react-test-renderer 16.4.1
+ enzyme 3.3.0
+ jest-environment-jsdom 23.2.0
+ weak 1.0.1

all the packages from pnpm
+ @vue/component-compiler-utils 2.0.0
+ ansi-styles 3.2.1
+ babel-core 6.26.3
+ babel-preset-env 1.7.0
+ babel-preset-react 6.24.1
+ fbjs 0.8.17
+ node-sass 4.9.0
+ object-assign 4.1.1
+ parcel-bundler 1.9.1
+ prop-types 15.6.1
+ react 16.4.1
+ react-dom 16.4.1
+ rimraf 2.6.2
+ typescript 2.9.2
+ vue 2.5.16
+ vue-hot-reload-api 2.3.0
+ vue-template-compiler 2.5.16

Might be a bit easier to use yarn as parcel installs packages with yarn.

Parcel
yarn add --dev  parcel-bundler rimraf node-sass
(remove .babelrc)

React
yarn add --dev react react-dom babel-preset-env babel-preset-react
running parcel will cause yarn to install some more packages

Vue
yarn add --dev vue
after running parcel and yarn tries to add packages,
run yarn install again to fix deps before trying again.

Typescript
yarn add --dev typescript

Prettier

yarn add --dev prettier

ESlint
yarn add --dev eslint eslint-plugin-prettier eslint-config-prettier
eslint --init

+ eslint 5.9.0

? How would you like to configure ESLint? Answer questions about your style
? Are you using ECMAScript 6 features? Yes
? Are you using ES6 modules? Yes
? Where will your code run? Browser, Node
? Do you use CommonJS? Yes
? Do you use JSX? Yes
? Do you use React Yes
? What style of indentation do you use? Tabs
? What quotes do you use for strings? Single
? What line endings do you use? Unix
? Do you require semicolons? No
? What format do you want your config file to be in? JavaScript
Installing eslint-plugin-react

Stylelint
pnpm install --save-dev stylelint stylelint-config-sass-guidelines stylelint-config-standard stylelint-config-recommended stylelint-config-prettier

# no... 
yarn add --dev stylelint stylelint-config-prettier stylelint-config-recommended stylelint-config-standard eslint-config-stylelint

Husky
pnpm install husky lint-staged

TODO react-test-library instead of enzyme and snapshot testing.
