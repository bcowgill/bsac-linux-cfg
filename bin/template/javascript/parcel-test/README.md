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
pnpm install --save-dev react react-dom fbjs prop-types object-assign babel-core babel-preset-env babel-preset-react
echo '{ "presets": [ "env", "react" ] }' > .babelrc
+ babel-core 6.26.3
+ babel-preset-env 1.7.0
+ babel-preset-react 6.24.1
+ fbjs 0.8.17
+ object-assign 4.1.1
+ prop-types 15.6.1
+ react 16.4.1
+ react-dom 16.4.1

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
