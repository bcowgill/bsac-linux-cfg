define(["require", "exports", "./ModuleExportEq"], function (require, exports, ModuleExports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    new ModuleExports.CExported('the name');
    // import the exports as named, cannot use this syntax either with export =
    /*import * as ModuleExports from './ModuleExportEq'
    
    ModuleExports.fnExport()
    ModuleExports.fnExport2()
    new ModuleExports.CExported('myname')
    */
    // import the exports giving them new names, cannot use this syntax:
    //import { fnExport as call1, fnExport2 as call2, CExported as CCme } from './ModuleExportEq'
    // have to assign variables to rename the exported symbols
    var call1 = ModuleExports.fnExport;
    var call2 = ModuleExports.fnExport2;
    var CCme = ModuleExports.CExported;
    call1();
    call2();
    new CCme('name2');
});
