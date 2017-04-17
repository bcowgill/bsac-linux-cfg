System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    function internal() { return "internal"; }
    // cannot export individual symbols when we use export = in a module
    /* export */ function fnExport() { return "exported" + internal(); }
    function rename() { return "rename"; }
    var CExported;
    return {
        setters: [],
        execute: function () {
            // export { rename as fnExport2 }
            CExported = (function () {
                function CExported(name) {
                    this.name = name;
                }
                return CExported;
            }());
        }
    };
});
