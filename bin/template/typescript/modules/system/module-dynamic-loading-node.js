System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var needZipValidation;
    return {
        setters: [],
        execute: function () {
            needZipValidation = true;
            if (needZipValidation) {
                var ZipCodeValidator = require("./ZipCodeValidator");
                var validator = new ZipCodeValidator();
                if (validator.isAcceptable("...")) { }
            }
        }
    };
});
