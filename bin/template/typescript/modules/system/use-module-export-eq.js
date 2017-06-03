// import the default export only, cannot use normal syntax as
// module has export = in it.
//import CDefault from './ModuleExportEq'
System.register(["./ModuleExportEq"], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var ModuleExports, call1, call2, CCme;
    return {
        setters: [
            function (ModuleExports_1) {
                ModuleExports = ModuleExports_1;
            }
        ],
        execute: function () {// import the default export only, cannot use normal syntax as
            // module has export = in it.
            //import CDefault from './ModuleExportEq'
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
            call1 = ModuleExports.fnExport;
            call2 = ModuleExports.fnExport2;
            CCme = ModuleExports.CExported;
            call1();
            call2();
            new CCme('name2');
        }
    };
});
