// import the default export only, cannot use normal syntax as
// module has export = in it.
//import CDefault from './ModuleExportEq'

// cannot use this import method in es2015 module formats (use import * as X ... or import {X} ..., or import X ...)
import ModuleExports = require('./ModuleExportEq')

new ModuleExports.CExported ('the name')

// import the exports as named, cannot use this syntax either with export =
/*import * as ModuleExports from './ModuleExportEq'

ModuleExports.fnExport()
ModuleExports.fnExport2()
new ModuleExports.CExported('myname')
*/

// import the exports giving them new names, cannot use this syntax:
//import { fnExport as call1, fnExport2 as call2, CExported as CCme } from './ModuleExportEq'
// have to assign variables to rename the exported symbols
const call1 = ModuleExports.fnExport
const call2 = ModuleExports.fnExport2
const CCme = ModuleExports.CExported

call1()
call2()
new CCme('name2')

