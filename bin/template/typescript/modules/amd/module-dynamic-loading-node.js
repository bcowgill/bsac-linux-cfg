define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var needZipValidation = true;
    if (needZipValidation) {
        var ZipCodeValidator = require("./ZipCodeValidator");
        var validator = new ZipCodeValidator();
        if (validator.isAcceptable("...")) { }
    }
});
