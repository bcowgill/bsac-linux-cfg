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
