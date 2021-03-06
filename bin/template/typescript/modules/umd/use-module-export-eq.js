// import the default export only, cannot use normal syntax as
// module has export = in it.
//import CDefault from './ModuleExportEq'
(function (factory) {
    if (typeof module === "object" && typeof module.exports === "object") {
        var v = factory(require, exports);
        if (v !== undefined) module.exports = v;
    }
    else if (typeof define === "function" && define.amd) {
        define(["require", "exports", "./ModuleExportEq"], factory);
    }
})(function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    // cannot use this import method in es2015 module formats (use import * as X ... or import {X} ..., or import X ...)
    var ModuleExports = require("./ModuleExportEq");
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
