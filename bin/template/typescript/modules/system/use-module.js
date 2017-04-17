System.register(["./Module"], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var Module_1, ModuleExports, Module_2, Module_3;
    return {
        setters: [
            function (Module_1_1) {
                Module_1 = Module_1_1;
                ModuleExports = Module_1_1;
                Module_2 = Module_1_1;
                Module_3 = Module_1_1;
            }
        ],
        execute: function () {
            new Module_1.default('the name');
            ModuleExports.fnExport();
            ModuleExports.fnExport2();
            new ModuleExports.CExported('myname');
            Module_2.fnExport();
            Module_2.fnExport2();
            new Module_2.CExported('name2');
            new Module_3.default('a name');
            Module_3.fnExport();
        }
    };
});
