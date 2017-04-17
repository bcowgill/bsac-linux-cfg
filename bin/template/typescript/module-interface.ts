//===============================================================
// module interfaces

// commonjs for node
// amd for requirejs in web applications

// use export keyword to export any interface, constant, variable or class declaration, type alias, or function

// export let MAX: number = 32;

// the default export for a module
// export default class MyThing {};

// export symbol under another name
// export { Symbol as SymbolAlias }

// import and re-export a symbol, renaming it without creating a local variable

// export { Symbol as SymbolAlias } from './Module'

// override the default export object with a class, interface, namespace, function or enum
// export = Symbol

// This can only be imported using typescript specific import =
// import symbol = require('./Module')

// import a symbol from module with ability to rename
// import { Symbol } from './Module'
// import { Symbol as SymbolAlias } from './Module'

// import all symbols into a single variable and use it to access the exports
// import * as Prefix from './Module'
// new Prefix.SomeClass()

// import for side effects only
// import './Module'
