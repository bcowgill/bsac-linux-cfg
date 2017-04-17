(function (factory) {
    if (typeof module === "object" && typeof module.exports === "object") {
        var v = factory(require, exports);
        if (v !== undefined) module.exports = v;
    }
    else if (typeof define === "function" && define.amd) {
        define(["require", "exports", "./ZipCodeValidator"], factory);
    }
})(function (require, exports) {
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
    // Export original validator but rename it
    var ZipCodeValidator_1 = require("./ZipCodeValidator");
    exports.RegExpBasedZipCodeValidator = ZipCodeValidator_1.ZipCodeValidator;
});
