"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var needZipValidation = true;
if (needZipValidation) {
    System.import("./ZipCodeValidator").then(function (ZipCodeValidator) {
        var x = new ZipCodeValidator();
        if (x.isAcceptable("...")) { }
    });
}
