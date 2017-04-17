System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    function internal() { return "internal"; }
    function fnExport() { return "exported" + internal(); }
    exports_1("fnExport", fnExport);
    function rename() { return "rename"; }
    exports_1("fnExport2", rename);
    var CExported;
    return {
        setters: [],
        execute: function () {
            CExported = (function () {
                function CExported(name) {
                    this.name = name;
                }
                return CExported;
            }());
            exports_1("CExported", CExported);
            exports_1("default", CExported);
        }
    };
});
