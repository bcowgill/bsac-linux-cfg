System.register(["./ZipCodeValidator", "./LettersOnlyValidator"], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var ZipCodeValidator_1, LettersOnlyValidator_1, strings, validators;
    return {
        setters: [
            function (ZipCodeValidator_1_1) {
                ZipCodeValidator_1 = ZipCodeValidator_1_1;
            },
            function (LettersOnlyValidator_1_1) {
                LettersOnlyValidator_1 = LettersOnlyValidator_1_1;
            }
        ],
        execute: function () {
            // Some samples to try
            strings = ["Hello", "98052", "101"];
            // Validators to use
            validators = {};
            validators["ZIP code"] = new ZipCodeValidator_1.ZipCodeValidator();
            validators["Letters only"] = new LettersOnlyValidator_1.LettersOnlyValidator();
            // Show whether each string passed each validator
            strings.forEach(function (s) {
                for (var name_1 in validators) {
                    console.log("\"" + s + "\" - " + (validators[name_1].isAcceptable(s) ? "matches" : "does not match") + " " + name_1);
                }
            });
        }
    };
});
