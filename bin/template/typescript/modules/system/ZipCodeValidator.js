System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var numberRegexp, ZipCodeValidator;
    return {
        setters: [],
        execute: function () {
            exports_1("numberRegexp", numberRegexp = /^[0-9]+$/);
            ZipCodeValidator = (function () {
                function ZipCodeValidator() {
                }
                ZipCodeValidator.prototype.isAcceptable = function (s) {
                    return s.length === 5 && numberRegexp.test(s);
                };
                return ZipCodeValidator;
            }());
            exports_1("ZipCodeValidator", ZipCodeValidator);
            exports_1("mainValidator", ZipCodeValidator);
        }
    };
});
