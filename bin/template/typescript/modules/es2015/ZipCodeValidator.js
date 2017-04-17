export var numberRegexp = /^[0-9]+$/;
var ZipCodeValidator = (function () {
    function ZipCodeValidator() {
    }
    ZipCodeValidator.prototype.isAcceptable = function (s) {
        return s.length === 5 && numberRegexp.test(s);
    };
    return ZipCodeValidator;
}());
export { ZipCodeValidator };
export { ZipCodeValidator as mainValidator };
