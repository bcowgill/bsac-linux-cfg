define(["require", "exports", "./ZipCodeValidator", "./LettersOnlyValidator"], function (require, exports, ZipCodeValidator_1, LettersOnlyValidator_1) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    // Some samples to try
    var strings = ["Hello", "98052", "101"];
    // Validators to use
    var validators = {};
    validators["ZIP code"] = new ZipCodeValidator_1.ZipCodeValidator();
    validators["Letters only"] = new LettersOnlyValidator_1.LettersOnlyValidator();
    // Show whether each string passed each validator
    strings.forEach(function (s) {
        for (var name_1 in validators) {
            console.log("\"" + s + "\" - " + (validators[name_1].isAcceptable(s) ? "matches" : "does not match") + " " + name_1);
        }
    });
});
