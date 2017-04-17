System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var needZipValidation;
    return {
        setters: [],
        execute: function () {
            needZipValidation = true;
            if (needZipValidation) {
                require(["./ZipCodeValidator"], function (ZipCodeValidator) {
                    var validator = new ZipCodeValidator.ZipCodeValidator();
                    if (validator.isAcceptable("...")) { }
                });
            }
        }
    };
});
