System.register(["./ZipCodeValidator"], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var ParseIntBasedZipCodeValidator;
    return {
        setters: [
            function (ZipCodeValidator_1_1) {
                exports_1({
                    "RegExpBasedZipCodeValidator": ZipCodeValidator_1_1["ZipCodeValidator"]
                });
            }
        ],
        execute: function () {
            ParseIntBasedZipCodeValidator = (function () {
                function ParseIntBasedZipCodeValidator() {
                }
                ParseIntBasedZipCodeValidator.prototype.isAcceptable = function (s) {
                    return s.length === 5 && parseInt(s).toString() === s;
                };
                return ParseIntBasedZipCodeValidator;
            }());
            exports_1("ParseIntBasedZipCodeValidator", ParseIntBasedZipCodeValidator);
        }
    };
});
