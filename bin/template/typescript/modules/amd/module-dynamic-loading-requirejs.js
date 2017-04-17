define(["require", "exports"], function (require, exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    var needZipValidation = true;
    if (needZipValidation) {
        require(["./ZipCodeValidator"], function (ZipCodeValidator) {
            var validator = new ZipCodeValidator.ZipCodeValidator();
            if (validator.isAcceptable("...")) { }
        });
    }
});
