define(["require", "exports", "./ZipCodeValidator"], function (require, exports, ZipCodeValidator_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var ParseIntBasedZipCodeValidator = (function () {
        function ParseIntBasedZipCodeValidator() {
        }
        ParseIntBasedZipCodeValidator.prototype.isAcceptable = function (s) {
            return s.length === 5 && parseInt(s).toString() === s;
        };
        return ParseIntBasedZipCodeValidator;
    }());
    exports.ParseIntBasedZipCodeValidator = ParseIntBasedZipCodeValidator;
    exports.RegExpBasedZipCodeValidator = ZipCodeValidator_1.ZipCodeValidator;
});
