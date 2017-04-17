(function (factory) {
    if (typeof module === "object" && typeof module.exports === "object") {
        var v = factory(require, exports);
        if (v !== undefined) module.exports = v;
    }
    else if (typeof define === "function" && define.amd) {
        define(["require", "exports"], factory);
    }
})(function (require, exports) {
    "use strict";
    function internal() { return "internal"; }
    // cannot export individual symbols when we use export = in a module
    /* export */ function fnExport() { return "exported" + internal(); }
    function rename() { return "rename"; }
    // export { rename as fnExport2 }
    var CExported = (function () {
        function CExported(name) {
            this.name = name;
        }
        return CExported;
    }());
    return {
        fnExport: fnExport, fnExport2: rename, CExported: CExported
    };
});
