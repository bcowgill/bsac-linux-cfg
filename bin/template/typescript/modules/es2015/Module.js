function internal() { return "internal"; }
export function fnExport() { return "exported" + internal(); }
function rename() { return "rename"; }
export { rename as fnExport2 };
var CExported = (function () {
    function CExported(name) {
        this.name = name;
    }
    return CExported;
}());
export default CExported;
// without this, CExported could not be accessed as import { CExported } from ...
export { CExported as CExported };
