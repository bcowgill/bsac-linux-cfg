define(["require", "exports", "./Module", "./Module", "./Module"], function (require, exports, Module_1, ModuleExports, Module_2) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    new Module_1.default('the name');
    ModuleExports.fnExport();
    ModuleExports.fnExport2();
    new ModuleExports.CExported('myname');
    Module_2.fnExport();
    Module_2.fnExport2();
    new Module_2.CExported('name2');
});
