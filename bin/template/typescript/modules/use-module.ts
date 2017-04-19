// import the default export only
import CDefault from './Module'
new CDefault('the name')

// import the exports as named
// (omits the default export unless explicitly exported)
import * as ModuleExports from './Module'

ModuleExports.fnExport()
ModuleExports.fnExport2()
new ModuleExports.CExported('myname')

// import the exports giving them new names
import { fnExport as call1, fnExport2 as call2, CExported as CCme } from './Module'

call1()
call2()
new CCme('name2')

// import the default and other exports in one go
import CCC, { fnExport as fnF } from './Module'
new CCC('a name')
fnF()

a
