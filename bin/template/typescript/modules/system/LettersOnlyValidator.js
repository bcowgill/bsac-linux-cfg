System.register([], function (exports_1, context_1) {
    "use strict";
    var __moduleName = context_1 && context_1.id;
    var lettersRegexp, LettersOnlyValidator;
    return {
        setters: [],
        execute: function () {
            lettersRegexp = /^[A-Za-z]+$/;
            LettersOnlyValidator = (function () {
                function LettersOnlyValidator() {
                }
                LettersOnlyValidator.prototype.isAcceptable = function (s) {
                    return lettersRegexp.test(s);
                };
                return LettersOnlyValidator;
            }());
            exports_1("LettersOnlyValidator", LettersOnlyValidator);
        }
    };
});
