"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
function internal() { return "internal"; }
function fnExport() { return "exported" + internal(); }
exports.fnExport = fnExport;
function rename() { return "rename"; }
exports.fnExport2 = rename;
var CExported = (function () {
    function CExported(name) {
        this.name = name;
    }
    return CExported;
}());
exports.CExported = CExported;
exports.default = CExported;
